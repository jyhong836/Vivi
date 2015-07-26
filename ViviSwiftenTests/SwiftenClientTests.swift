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
    
    let eventLoop: SWEventLoop! = SWEventLoop()
    
    let client1AccountString = "jyhong@xmpp.jp/testResource"
    let client1PasswdString = "jyhong123"
    let client2AccountString = "jyhong1@xmpp.jp/testResource"
    let client2PasswdString = "jyhong123"

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: Non-delay tests
    func testClient1AccountString() {
        let client1 = SWClient(accountString: client1AccountString, password: client1PasswdString, eventLoop: eventLoop)
        let account = client1.account
        XCTAssertEqual(account.getAccountString(), "jyhong@xmpp.jp", "Account string \"\(account.getAccountString())\" not correspond to setting \"jyhong@xmpp.jp\"")
        XCTAssertEqual(account.getFullAccountString(), client1AccountString, "Account string \"\(account.getFullAccountString())\" not correspond to setting \"\(client1AccountString)\"")
        XCTAssertEqual(account.getDomainString(), "xmpp.jp", "Account domain \"\(account.getDomainString())\" not correspond to setting \"xmpp.jp\"")
        XCTAssertEqual(account.getResourceString(), "testResource", "Account resource \"\(account.getResourceString())\" not correspond to setting \"testResource\"")
        XCTAssertEqual(account.getNodeString(), "jyhong", "Account resource \"\(account.getNodeString())\" not correspond to setting \"jyhong\"")
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
        let client1 = SWClient(accountString: client1AccountString, password: client1PasswdString, eventLoop: eventLoop)
        XCTAssertNil(client1.delegate, "delegate should be nil")
        
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
        XCTAssertTrue(client1.isConnected, "client1 should have been connected")
        
        
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
        XCTAssertTrue(!client1.isConnected, "client1 should have been disconnected")
    }
    
    func testTwoClientConnect() {
        let client1 = SWClient(accountString: client1AccountString, password: client1PasswdString, eventLoop: eventLoop)
        let client2 = SWClient(accountString: client2AccountString, password: client2PasswdString, eventLoop: eventLoop)
        
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
        let client1 = SWClient(accountString: client1AccountString, password: client1PasswdString, eventLoop: eventLoop)
        let client2 = SWClient(accountString: client2AccountString, password: client2PasswdString, eventLoop: eventLoop)
        
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
        
        clientConnectExpectation = self.expectationWithDescription("test client1 connecting")
        _clientDidConnect = {(c: SWClient!)->Void in
            XCTAssertEqual(c, client1, "connected client not equal to expected")
            clientConnectExpectation?.fulfill()
        }
        client1.connect()
        waitForExpectationsWithTimeout(30, handler: nil)
        
        clientConnectExpectation = self.expectationWithDescription("test client2 connecting")
        _clientDidConnect = {(c: SWClient!)->Void in
            XCTAssertEqual(c, client2, "connected client not equal to expected")
            clientConnectExpectation?.fulfill()
        }
        client2.connect()
        waitForExpectationsWithTimeout(30, handler: nil)
        
        clientConnectExpectation = self.expectationWithDescription("test client1 and client2 message exchange")
        client1.sendMessageToAccount(client2.account, message: c1string)
        
        waitForExpectationsWithTimeout(20, handler: nil)
    }
    
//    optional func clientDidReceivePresence(client: SWClient!, fromAccount account: SWAccount!, currentPresence presenceType: Int32, currentShow show: Int32, currentStatus status: AnyObject!)
}
