//
//  SwiftenClientTests.swift
//  Vivi
//
//  Created by Junyuan Hong on 7/23/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import XCTest
import ViviSwiften

var clientTestExectiation: XCTestExpectation?

class SwiftenClientTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        setSharedVivi(TSVivi())
        vivi.clientController.controllerDidLoad()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        vivi.clientController.controllerWillClose()
    }

//    func testExample() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
//
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
    func testConnection() {
        clientTestExectiation = self.expectationWithDescription("client connection")
        vivi.clientController.client.connect()
        waitForExpectationsWithTimeout(50, handler: nil)
        vivi.clientController.client.sendMessageToAccount(SWAccount("jyhong1@xmpp.jp"), message: "hello")
    // ***********************************************************
    // MARK: *** You must send message to the account in hand. ***
    // ***********************************************************
        clientTestExectiation = self.expectationWithDescription("** wait for receiving a message **")
        waitForExpectationsWithTimeout(50, handler: nil)
    }

}
