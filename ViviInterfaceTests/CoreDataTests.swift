//
//  CoreDataTests.swift
//  Vivi
//
//  Created by Junyuan Hong on 8/19/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import XCTest
import CoreData
import ViviInterface

class CoreDataTests: XCTestCase {
    
    lazy var coreDataController = VICoreDataController.shared
    
    var moc: NSManagedObjectContext?

    override func setUp() {
        super.setUp()
        
        let mom = coreDataController.managedObjectModel
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        do {
            try psc.addPersistentStoreWithType(NSInMemoryStoreType, configuration: nil, URL: nil, options: nil)
            moc = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
            moc!.persistentStoreCoordinator = psc
        } catch {
            fatalError("Fail to add persistent store with type(NSInMemoryStoreType): \(error)")
        }
    }
    
    override func tearDown() {
        super.tearDown()
        
        moc = nil
    }
    
    func testInsertAccount() {
        var hasCatchError = false
        var testnode = "te#st.no@de"
        var testdomain = "test.domain"
        do {
            try VIAccountMO.addAccount(testnode, domain: testdomain, managedObjectContext: moc!)
        } catch {
            hasCatchError = true
        }
        XCTAssertTrue(hasCatchError, "Not catch invalid error")
        XCTAssertNil(VIAccountMO.getAccount(testnode, domain: testdomain, managedObjectContext: moc!), "entity should have been removed.")
        
        hasCatchError = false
        testdomain = "test.dom#ain"
        do {
            try VIAccountMO.addAccount(testnode, domain: testdomain, managedObjectContext: moc!)
        } catch {
            hasCatchError = true
        }
        XCTAssertTrue(hasCatchError, "Not catch invalid error")
        
        testnode = "test.node"
        testdomain = "test.domain"
        do {
            try VIAccountMO.addAccount(testnode, domain: testdomain, managedObjectContext: moc!)
        } catch {
            XCTFail("catch unexpected error: \(error)")
        }
    }
    
    func testGetAccount() {
        let testnode = "te#st.no@de"
        let testdomain = "test.domain"
        XCTAssertNil(VIAccountMO.getAccount(testnode, domain: testdomain, managedObjectContext: moc!), "get not existed account.")
    }

}
