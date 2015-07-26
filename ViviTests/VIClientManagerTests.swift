//
//  ClientManagerTests.swift
//  Vivi
//
//  Created by Junyuan Hong on 7/26/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import XCTest
@testable import VIVivi
import ViviSwiften

class ClientManagerTests: XCTestCase {
    
    var clientManager: VIClientManagerProtocol!
    let client1AccountString = "jyhong@xmpp.jp/testResource"
    let client1PasswdString = "jyhong123"
    let client2AccountString = "jyhong1@xmpp.jp/testResource"
    let client2PasswdString = "jyhong123"

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        clientManager = VIClientManager.sharedClientManager
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        (clientManager as! VIClientManager).clientList.removeAll()
    }
    
    func testAddClientToManagerWithAccountName() {
        XCTAssertEqual(clientManager.getClientCount(), 0, "client count is not zero at begining!")
        let idx1 = clientManager.addClient(withAccountName: client1AccountString, andPasswd: client1PasswdString)
        XCTAssertEqual(clientManager.getClientCount(), 1, "client count should be 1 after add one client!")
        XCTAssertNotNil(idx1, "client index should not be nil")
        XCTAssertEqual(idx1!, 0, "the index of client1 not equal to expected")
        let idx2 = clientManager.addClient(withAccountName: client2AccountString, andPasswd: client2PasswdString)
        XCTAssertEqual(clientManager.getClientCount(), 2, "client count not equal to expected after add two client!")
        XCTAssertNotNil(idx2, "client index should not be nil")
        XCTAssertEqual(idx2!, 1, "the index of client1 not equal to expected")
        let idx3 = clientManager.addClient(withAccountName: client2AccountString, andPasswd: client2PasswdString)
        XCTAssertEqual(clientManager.getClientCount(), 2, "client count should be 2 after add three client including one duplicated!")
        XCTAssertNotNil(idx3, "client index should not be nil")
        XCTAssertEqual(idx3!, idx2!, "add duplicated client should return same index")
    }
    
    func testAddClientToManagerWithAccount() {
        XCTAssertEqual(clientManager.getClientCount(), 0, "client count is not zero at begining!")
        let idx1 = clientManager.addClient(withAccount: SWAccount(client1AccountString), andPasswd: client1PasswdString)
        XCTAssertEqual(clientManager.getClientCount(), 1, "client count should be 1 after add one client!")
        XCTAssertNotNil(idx1, "client index should not be nil")
        XCTAssertEqual(idx1!, 0, "the index of client1 should 1")
        let idx2 = clientManager.addClient(withAccount: SWAccount(client2AccountString), andPasswd: client2PasswdString)
        XCTAssertEqual(clientManager.getClientCount(), 2, "client count should be 2 after add two client!")
        XCTAssertNotNil(idx2, "client index should not be nil")
        XCTAssertEqual(idx2!, 1, "the index of client1 should 2")
        let idx3 = clientManager.addClient(withAccount: SWAccount(client2AccountString), andPasswd: client2PasswdString)
        XCTAssertEqual(clientManager.getClientCount(), 2, "client count should be 2 after add three client including one duplicated!")
        XCTAssertNotNil(idx3, "client index should not be nil")
        XCTAssertEqual(idx3!, idx2!, "add duplicated client should return same index")
    }
    
    func testAccessClient() {
        XCTAssertEqual(0, clientManager.getClientCount(), "client count is not zero at begining!")
        let idx1 = clientManager.addClient(withAccountName: client1AccountString, andPasswd: client1PasswdString)
        XCTAssertEqual(1, clientManager.getClientCount(), "client count should be 1 after add one client but get \(clientManager.getClientCount())!")
        XCTAssertNotNil(idx1, "client index should not be nil")
        XCTAssertEqual(0, idx1!, "index of client1 not equal to expected")
        let client1 = clientManager.getClientAtIndex(idx1!)
        XCTAssertNotNil(client1, "added client1 should be accessable")
        let idx1r = clientManager.indexOfClient(client1!)
        XCTAssertEqual(idx1!, idx1r!, "access client return wrong index")
        
        let account2 = SWAccount(client2AccountString)
        var idx2: ClientIndex? = 2
        
        var client2 = clientManager.getClientAtIndex(idx2!)
        XCTAssertNil(client2, "access not added client with index \(idx2) should return nil")
        
        idx2 = clientManager.addClient(withAccount: account2, andPasswd: client1PasswdString)
        client2 = clientManager.getClientAtIndex(idx2)
        XCTAssertEqual(idx2!, clientManager.indexOfClient(client2)!, "access client return wrong index")
        
        clientManager.removeClient(client1)
        XCTAssertEqual(clientManager.indexOfClient(client2)!, 0, "index of client2 is not moved to expected")
        XCTAssertNil(clientManager.indexOfClient(client1), "index of client1 should not be accessable now!")
        
        XCTAssertNil(clientManager.indexOfClient(nil), "index of nil client should be nil")
        XCTAssertNil(clientManager.getClientAtIndex(nil), "nil index should access nil")
    }
    
    func testInvalidPasswordCharacter() {
        let idx1 = clientManager.addClient(withAccountName: client1AccountString, andPasswd: "测试中文密码")
        XCTAssertNil(idx1, "index should be nil for invalid passed character")
    }
}
