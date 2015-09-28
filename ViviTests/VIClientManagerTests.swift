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
        clientMgr.forceRemoveAllClient()
    }
    
    // MARK: test adding client
    
    func addClientWithName(index: Int) throws -> SWClient? {
        return try clientMgr.addClient(withAccountName: clientAccountString[index], andPasswd: clientPasswdString[index])
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
    
    func testAddClientWithAccountName() {
        /// Include confict test
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
            
            do {
                shouldCatchConflictError = true
                // confilct without resource
                try clientMgr.addClient(withAccountName: "jyhong@xmpp.jp", andPasswd: "xx")
            } catch VIClientManagerError.AccountNameConfilct {
                hasCatchConflictError = true
            } catch {
                XCTFail("Throw unexpected error")
            }
            if shouldCatchConflictError {
                XCTAssertTrue(hasCatchConflictError, "Add conflict client didn't throw AccountNameConfilct Error")
            }
        }
        
        addClientWithMethod(method: addClientWithName)
    }
    
    func testIndexNil() {
        XCTAssertNil(clientMgr.currentIndexOfClient(nil), "Index for nil client should be nil")
    }
    
    func stubAddClient(index: Int) -> (Bool, SWClient?) {
        do {
            let client1 = try addClientWithName(0)
            if client1 == nil || clientMgr.currentIndexOfClient(client1) == nil {
                return (false, nil)
            } else {
                return (true, client1)
            }
        } catch {
            XCTFail("Unexpected ERROR")
            return (false, nil)
        }
    }
    
    // TODO: Remove client is aync now. Use new method to test it.
//    func testARemoveAllClient() {
//        let (success, client) = stubAddClient(0)
//        if success {
//            clientMgr.removeAllClient()
//            XCTAssertNil(clientMgr.currentIndexOfClient(client))
//            XCTAssertEqual(clientMgr.clientCount, 0, "Client count error after remove one client")
//        } else {
//            XCTFail("Fail to add client")
//        }
//    }

//    func testRemoveClient() {
//        let (success, client) = stubAddClient(0)
//        if success {
//            clientMgr.removeClient(client)
//            XCTAssertNil(clientMgr.currentIndexOfClient(client))
//            XCTAssertEqual(clientMgr.clientCount, 0, "Client count error after remove one client")
//        } else {
//            XCTFail("Fail to add client")
//        }
//    }
    
    func testGetClient() {
        let i: Int = 0
        let (success, client) = stubAddClient(i)
        if success {
            let c = clientMgr.getClient(withAccountName: clientAccountString[i])
            XCTAssertNotNil(c, "Cannot get client with string")
            if c != nil {
                XCTAssertEqual(client!, c!, "Get wrong client")
            }
            XCTAssertNil(clientMgr.getClient(withAccountName: "非ASCII"), "Can return nil for non-ascii string")
        } else {
            XCTFail("Fail to add client")
        }
    }
    
    func testInvalidPasswordCharacter() {
        var hasCatchError = false
        do {
            try clientMgr.addClient(withAccountName: clientAccountString[0], andPasswd: "测试中文密码")
        }catch VIClientManagerError.ClientPasswordUnconvertible {
            hasCatchError = true
        } catch {
            XCTFail("Unknown ERROR")
        }
        XCTAssertTrue(hasCatchError, "Client can't throw ClientPasswordUnconvertible Error")
    }
    
    func testInvalidAccountCharacter() {
        var hasCatchError = false
        do {
            try clientMgr.addClient(withAccountName: "测试中文账号", andPasswd: "测试中文密码")
        }catch VIClientManagerError.ClientAccountNameUnconvertible {
            hasCatchError = true
        } catch {
            XCTFail("Unknown ERROR")
        }
        XCTAssertTrue(hasCatchError, "Client can't throw ClientAccountNameUnconvertible Error")
    }
    
    func testAddTooManyClient() {
        var hasCatchError = false
        do {
            for i in 1 ... clientMgr.maxClientCount + 1 {
                try clientMgr.addClient(withAccountName: "c\(i)", andPasswd: "p")
            }
        } catch VIClientManagerError.TooManyClients {
            hasCatchError = true
        } catch {
            XCTFail("Unexpected Error")
        }
        XCTAssertTrue(hasCatchError, "AddClient didn't throw TooManyClients ERROR")
        
        XCTAssertEqual(clientMgr.clientCount, clientMgr.maxClientCount, "ClientManager didn't control the max number of clients")
    }
}
