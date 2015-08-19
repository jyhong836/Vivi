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
            moc?.persistentStoreCoordinator = psc
        } catch {
            fatalError("Fail to add persistent store with type(NSInMemoryStoreType): \(error)")
        }
    }
    
    override func tearDown() {
        super.tearDown()
        
        moc = nil
    }
    
    func testInsertAccount() {
        
    }

}
