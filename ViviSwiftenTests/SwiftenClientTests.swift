//
//  SwiftenClientTests.swift
//  Vivi
//
//  Created by Junyuan Hong on 7/23/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import XCTest
@testable import ViviSwiften

class SwiftenClientTests: XCTestCase, VSClientDelegate {
    
    var eventLoop: SWEventLoop! = SWEventLoop()
    
    let clientAccountString = ["jyhong@xmpp.jp/testResource", "jyhong1@xmpp.jp/testResource"]
    let clientPasswdString = ["jyhong123", "jyhong123"]

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    private func createClient(index: Int) -> SWClient {
        let c =  SWClient(account: SWAccount(accountName: clientAccountString[index]), password: clientPasswdString[index], eventLoop: eventLoop)
        c.delegate = self
        return c
    }
    
    // MARK: Non-delay tests
    func testClient1AccountString() {
        let idx = 0
        let client1 = createClient(idx)
        let account = client1.account
        XCTAssertEqual(account.getAccountString(), "jyhong@xmpp.jp", "Account string \"\(account.getAccountString())\" not correspond to setting \"jyhong@xmpp.jp\"")
        XCTAssertEqual(account.getFullAccountString(), clientAccountString[idx], "Account string does not correspond")
        XCTAssertEqual(account.getDomainString(), "xmpp.jp", "Account domain not correspond to setting \"xmpp.jp\"")
        XCTAssertEqual(account.getResourceString(), "testResource", "Account resource not correspond")
        XCTAssertEqual(account.getNodeString(), "jyhong", "Account resource  not correspond")
        // TODO: Add test for password
    }
    
    func testEventLoop() {
        XCTAssertTrue(!eventLoop.isStarted)
        eventLoop.start()
        XCTAssertTrue(eventLoop.isStarted)
        eventLoop.stop()
        XCTAssertTrue(!eventLoop.isStarted)
    }
    
    // MARK: Delay tests for connection establishing
    var _clientDidConnect: ((SWClient!)->Void)? = nil
    func clientDidConnect(client: SWClient!) {
        _clientDidConnect?(client)
    }
    var _clientDidDisconnect: ((SWClient!, Int32)->Void)? = nil
    func clientDidDisconnect(client: SWClient!, errorCode code: Int32) {
        _clientDidDisconnect?(client, code)
    }
    func verifyImplement(client: SWClient!) {
        let connectSelector = "clientDidConnect:"
        let disconnectSelector = "clientDidDisconnect:errorCode:"
        if !client.delegate.respondsToSelector( Selector(connectSelector)) {
            let e = NSException(name:"NotImplement", reason:"Unimplement or incorrectly implementat \(connectSelector)", userInfo:nil)
            e.raise()
        }
        if !client.delegate.respondsToSelector( Selector(disconnectSelector)) {
            let e = NSException(name:"NotImplement", reason:"Unimplement or incorrectly implementat \(disconnectSelector)", userInfo:nil)
            e.raise()
        }
    }
    func testClient1Connect() {
        let client1 = createClient(0)
        
        client1.delegate = self
        
        eventLoop.start()
        
        var clientConnectExpectation: XCTestExpectation?
        
        verifyImplement(client1)
        
        // test client connecting
        clientConnectExpectation = self.expectationWithDescription("test client connecting")
        _clientDidConnect = {(c: SWClient!)->Void in
            XCTAssertEqual(c, client1, "connected client not equal to expected")
            NSLog("** connection established! **")
            clientConnectExpectation?.fulfill()
        }
        
        client1.connect()
        waitForExpectationsWithTimeout(50, handler: nil)
        XCTAssertTrue(client1.isAvailable(), "client1 should have been connected")
        
        
        // test client disconnecting
        clientConnectExpectation = self.expectationWithDescription("test client disconnecting")
        _clientDidDisconnect = {(c: SWClient!, e: Int32) in
            XCTAssertEqual(c, client1, "disconnected client not equal to expected")
            NSLog("** connection ended! **")
            XCTAssertLessThan(e, 0, "disconnect with unexpected error: \(e)")
            clientConnectExpectation?.fulfill()
        }
        // FIXME: Client disconnect sometimes go wrong with EXC_BAD_ACCESS. Although can be fixed with check NSZombieEnabled.
        client1.disconnect()
        waitForExpectationsWithTimeout(50, handler: nil)
        XCTAssertTrue(!client1.isAvailable(), "client1 should have been disconnected")
    }
    
    func testTwoClientConnect() {
        let client1 = createClient(0)
        let client2 = createClient(1)
        
        client1.delegate = self
        client2.delegate = self
        
        eventLoop.start()
        var clientConnectExpectation: XCTestExpectation?
        
        
        clientConnectExpectation = self.expectationWithDescription("test client1 connecting")
        _clientDidConnect = {(c: SWClient!)->Void in
            XCTAssertEqual(c, client1, "connected client not equal to expected")
            clientConnectExpectation?.fulfill()
        }
        client1.connect()
        waitForExpectationsWithTimeout(50, handler: nil)
        
        clientConnectExpectation = self.expectationWithDescription("test client2 connecting")
        _clientDidConnect = {(c: SWClient!)->Void in
            XCTAssertEqual(c, client2, "connected client not equal to expected")
            clientConnectExpectation?.fulfill()
        }
        client2.connect()
        waitForExpectationsWithTimeout(50, handler: nil)
    }
    
    // MARK: Delay test for two client comunicating
    var _clientDidReceiveMessage: ((SWClient!, SWAccount!, String!)->Void)? = nil
    func clientDidReceiveMessage(client: SWClient!, fromAccount account: SWAccount!, inContent content: String!) {
        _clientDidReceiveMessage?(client, account, content)
    }
    
    func testTwoClientMsgExchange() {
        let client1 = createClient(0)
        let client2 = createClient(1)
        
        client1.delegate = self
        client2.delegate = self
        
        let c1string = "Hello from client 1"
        let c2string = "Hi from client 2"
        let endstring = "END"
        var clientConnectExpectation: XCTestExpectation?
        
        _clientDidReceiveMessage = {(c: SWClient!, a: SWAccount!, msg: String!)->Void in
            if c == client1 {
                if msg == c2string {
                    c.sendMessageToAccount(client2.account, message: endstring)
                } else {
                    XCTFail("Receive unexpected message: \(msg)")
                }
            } else if c == client2 {
                if msg == c1string {
                    c.sendMessageToAccount(client1.account, message: c2string)
                } else if msg == endstring {
                    clientConnectExpectation?.fulfill()
                } else {
                    XCTFail("Receive unexpected message: \(msg)")
                }
            }
        }
        
        eventLoop.start()
        
        connectToClient(client1)
        connectToClient(client2)
        
        clientConnectExpectation = self.expectationWithDescription("test client1 and client2 message exchange")
        client1.sendMessageToAccount(client2.account, message: c1string)
        
        waitForExpectationsWithTimeout(20, handler: nil)
        
    }
    
    var _clientDidReceivePresence: ((client: SWClient!, account: SWAccount!, presenceType: Int32, show: Int32, status: String!) -> Void)? = nil
    func clientDidReceivePresence(client: SWClient!, fromAccount account: SWAccount!, currentPresence presenceType: Int32, currentShow show: Int32, currentStatus status: String!) {
        if let cb = _clientDidReceivePresence {
            cb(client: client, account: account, presenceType: presenceType, show: show, status: status)
        }
    }
    
    func connectToClient(client: SWClient) {
        let clientConnectExpectation = self.expectationWithDescription("Fail to connect to \(client.account.getFullAccountString())")
        _clientDidConnect = {(c: SWClient!)->Void in
            XCTAssertEqual(c, client, "connected client not equal to expected")
            print("connected to \(client.account.getFullAccountString())")
            clientConnectExpectation.fulfill()
        }
        client.connect()
        waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    // Not validate test
//    func testDeleteOneClient() {
//        var client1:SWClient? = createClient(0)
//        client1?.delegate = self
//        client1?.connectWithHandler({ () -> Void in
//            NSLog("connected to %@", client1?.account.getFullAccountString())
//        })
//        client1?.disconnectWithHandler({ () -> Void in
//            client1 = nil
//        })
//    }
//    
//    func testDelete() {
//        var client1:SWClient? = createClient(0)
//        var client2:SWClient? = createClient(1)
//        client1?.delegate = self
//        client2?.delegate = self
//        eventLoop.start()
//        
//        connectToClient(client2!)
//        connectToClient(client1!)
//        
//        var expect: XCTestExpectation!
//        _clientDidDisconnect = {
//            (c: SWClient!, e: Int32)->Void in
//            if c == client1 {
//                expect.fulfill()
//            } else if c == client2 {
//                expect.fulfill()
//            }
//        }
//        
//        client1?.disconnect()
//        expect = self.expectationWithDescription("Client not succss disconnect")
//        waitForExpectationsWithTimeout(20, handler: nil)
//        
//        client2?.disconnect()
//        expect = self.expectationWithDescription("Client not succss disconnect")
//        waitForExpectationsWithTimeout(20, handler: nil)
//
//        XCTAssertFalse(client1!.isActive(), "Client is not disconnected correctly.")
//        XCTAssertFalse(client2!.isActive(), "Client is not disconnected correctly.")
//        
//        client1 = nil
//        // FIXME: client2 is not released indead.
//        client2 = nil
//    }
}
