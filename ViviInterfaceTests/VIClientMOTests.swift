//
//  VIClientMOTests.swift
//  Vivi
//
//  Created by Junyuan Hong on 8/19/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import XCTest
@testable import ViviInterface

class VIClientMOTests: XCTestCase {
    
    var moc: NSManagedObjectContext?
    
    override func setUp() {
        super.setUp()
        
        moc = setUpCoreData()
    }
    
    override func tearDown() {
        moc = nil
        
        super.tearDown()
    }

}
