//
//  ClientManagerTests.swift
//  Vivi
//
//  Created by Junyuan Hong on 7/26/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import XCTest
@testable import ViviInterface
import ViviSwiften

class ClientManagerTests: XCTestCase {
    
    var clientMgr: VIClientManager!
    let clientAccountString = ["jyhong@xmpp.jp/testResource", "jyhong1@xmpp.jp/testResource"]
    let clientPasswdString = ["jyhong123", "jyhong123"]

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        clientMgr = VIClientManager.sharedClientManager
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        clientMgr.removeAllClient()
    }
    
    // MARK: test adding client
    
    func addClientWithName(index: Int) throws -> SWClient? {
        return try clientMgr.addClient(withAccountName: clientAccountString[index], andPasswd: clientPasswdString[index])
    }
    func addClientWithAccount(index: Int) throws -> SWClient? {
        return try clientMgr.addClient(withAccount: SWAccount(clientAccountString[index]), andPasswd: clientPasswdString[index])
    }
    func assertAddedClientNotNil(client1: SWClient?, expectedClientCount: Int, expectedCurrentIndex: Int, message: String) -> Bool {
        XCTAssertNotNil(
            client1,
            message
        )
        if client1 == nil {
            return false
        }
        XCTAssertEqual(
            clientMgr.clientCount,
            expectedClientCount,
            "Unexpected client count after adding client"
        )
        XCTAssertNotNil(
            clientMgr.currentIndexOfClient(client1),
            "Current index of client shouldn't be nil"
        )
        if clientMgr.currentIndexOfClient(client1) != nil {
            XCTAssertEqual(
                clientMgr.currentIndexOfClient(client1)!,
                expectedCurrentIndex,
                "Unexpected client index after adding client"
            )
        }
        return true
    }
    
    func addClientWithMethod(method addClient: (index: Int)throws->SWClient?) {
        XCTAssertEqual(
            clientMgr.clientCount,
            0,
            "Client count is not zero at begining"
        )
        var shouldCatchConflictError = false
        var hasCatchConflictError = false
        do {
            let client1 = try addClient(index: 0)
            if !assertAddedClientNotNil(client1, expectedClientCount: 1, expectedCurrentIndex: 0, message: "Can't add client, addClient will return nil") {
                return
            }
            let client2 = try addClient(index: 1)
            if !assertAddedClientNotNil(client2, expectedClientCount: 2, expectedCurrentIndex: 1, message: "Can't add client, addClient will return nil") {
                return
            }
            
            // add duplicated client
            shouldCatchConflictError = true
            try addClient(index: 1)
        } catch VIClientManagerError.AccountNameConfilct {
            hasCatchConflictError = true
        } catch {
            XCTFail("Throw unexpected error")
        }
        if shouldCatchConflictError {
            XCTAssertTrue(hasCatchConflictError, "Add conflict client didn't throw AccountNameConfilct Error")
        } else {
            XCTAssertFalse(hasCatchConflictError, "Throw unexpected AccountNameConfilct Error")
        }
    }
    
    func testAddClientWithAccountName() {
        addClientWithMethod(method: addClientWithName)
    }
    
    func testAddClientWithAccount() {
        addClientWithMethod(method: addClientWithAccount)
    }
    
    func testIndexNil() {
        XCTAssertNil(clientMgr.currentIndexOfClient(nil), "Index for nil client should be nil")
    }
    
    func testRemoveClient() {
        
    }
    
    func testAccessClient() {
//        XCTAssertEqual(0, clientManager.getClientCount(), "client count is not zero at begining!")
//        let idx1 = clientManager.addClient(withAccountName: client1AccountString, andPasswd: client1PasswdString)
//        XCTAssertEqual(1, clientManager.getClientCount(), "client count should be 1 after add one client but get \(clientManager.getClientCount())!")
//        XCTAssertNotNil(idx1, "client index should not be nil")
//        XCTAssertEqual(0, idx1!, "index of client1 not equal to expected")
//        let client1 = clientManager.getClientAtIndex(idx1!)
//        XCTAssertNotNil(client1, "added client1 should be accessable")
//        let idx1r = clientManager.indexOfClient(client1!)
//        XCTAssertEqual(idx1!, idx1r!, "access client return wrong index")
//        
//        let account2 = SWAccount(client2AccountString)
//        var idx2: ClientIndex? = 2
//        
//        var client2 = clientManager.getClientAtIndex(idx2!)
//        XCTAssertNil(client2, "access not added client with index \(idx2) should return nil")
//        
//        idx2 = clientManager.addClient(withAccount: account2, andPasswd: client1PasswdString)
//        client2 = clientManager.getClientAtIndex(idx2)
//        XCTAssertEqual(idx2!, clientManager.indexOfClient(client2)!, "access client return wrong index")
//        
//        clientManager.removeClient(client1)
//        XCTAssertEqual(clientManager.indexOfClient(client2)!, 0, "index of client2 is not moved to expected")
//        XCTAssertNil(clientManager.indexOfClient(client1), "index of client1 should not be accessable now!")
//        
//        XCTAssertNil(clientManager.indexOfClient(nil), "index of nil client should be nil")
//        XCTAssertNil(clientManager.getClientAtIndex(nil), "nil index should access nil")
    }
    
    func testInvalidPasswordCharacter() {
//        let idx1 = clientManager.addClient(withAccountName: client1AccountString, andPasswd: "测试中文密码")
//        XCTAssertNil(idx1, "index should be nil for invalid passed character")
    }
}
