//
//  EntityCapsTests.swift
//  Vivi
//
//  Created by Junyuan Hong on 9/28/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import XCTest
@testable import ViviSwiften

class EntityCapsTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    private func createClient(index: Int) -> SWClient {
        let c =  SWClientFactory.createClient(index)
        return c
    }
    
    var clientConnectExpectation: XCTestExpectation?

    func testExample() {
        let client1 = createClient(0)
        let client2 = createClient(1)
        SWClientFactory.eventLoop.start()
        
        clientConnectExpectation = self.expectationWithDescription("test client connecting")
        
        client1.connectWithHandler { (err) -> Void in
            print("connected client1")
            self.clientConnectExpectation?.fulfill()
        }
        waitForExpectationsWithTimeout(50, handler: nil)
        clientConnectExpectation = self.expectationWithDescription("test client connecting")
        client2.connectWithHandler { (err) -> Void in
            print("connected client2")
            self.clientConnectExpectation?.fulfill()
        }
        waitForExpectationsWithTimeout(50, handler: nil)
        
//        client1.
    }

}
