//
//  ViviTests.swift
//  ViviTests
//
//  Created by Junyuan Hong on 7/21/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import XCTest
import ViviSwiften

class ViviTests: XCTestCase, VSVivi {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        clientController = ClientController()
        clientController?.controllerDidLoad()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        clientController?.controllerWillClose()
    }
    
//    func testExample() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        XCTAssert(false)
//    }
//    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock() {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
    // MARK: VSVivi implementation
    
    var clientController: VSClientController?
    var isQuitting: Bool = false
    
    override init() {
        super.init()
        setSharedVivi(self)
        // TODO: do things to init controllers
        //        clientController!.
    }
    
    // MARK: My test codes
    
    func testViviClient() {
        
    }
    
}
