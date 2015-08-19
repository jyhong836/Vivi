//
//  TestUtils.swift
//  Vivi
//
//  Created by Junyuan Hong on 7/27/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import XCTest
import CoreData
import ViviInterface

//func ExtXCTAssertNotNil(@autoclosure expression: () -> AnyObject?, notNilDo trueHandler: (AnyObject)->Void, _ message: String) {
//    if let v = expression() {
//        trueHandler(v)
//    } else {
//        XCTAssertNotNil(expression, message)
//    }
//}

func setUpCoreData() -> NSManagedObjectContext {
    let coreDataController = VICoreDataController.shared
    
    let mom = coreDataController.managedObjectModel
    let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
    do {
        try psc.addPersistentStoreWithType(NSInMemoryStoreType, configuration: nil, URL: nil, options: nil)
        let moc = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        moc.persistentStoreCoordinator = psc
        return moc
    } catch {
        fatalError("Fail to add persistent store with type(NSInMemoryStoreType): \(error)")
    }
}
