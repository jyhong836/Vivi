//
//  SwiftenClientTests.swift
//  Vivi
//
//  Created by Junyuan Hong on 7/23/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import XCTest
@testable import ViviSwiften

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
        var clientTestExectiation: XCTestExpectation? = self.expectationWithDescription("client connection")
//        vivi.clientController.client.connect()
        let clientCtrl = vivi.clientController as! TSClientController
        clientCtrl.connectWithHandler({()->Void in
            XCTAssert(true, "Client connected")
            if let clientEXC = clientTestExectiation {
                clientEXC.fulfill()
                clientTestExectiation = nil
            }
        })
        waitForExpectationsWithTimeout(50, handler: nil)
        
        clientTestExectiation = self.expectationWithDescription("** wait for receiving a message **")
        vivi.clientController.client.sendMessageToAccount(SWAccount("jyhong1@xmpp.jp"), message: "hello")
    // ***********************************************************
    // MARK: *** You must send message to the account in hand. ***
    // ***********************************************************
        waitForExpectationsWithTimeout(50, handler: nil)
    }

}
