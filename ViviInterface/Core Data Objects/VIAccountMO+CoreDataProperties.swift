//
//  Account+CoreDataProperties.swift
//  Vivi
//
//  Created by Junyuan Hong on 8/11/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

import Foundation
import CoreData

extension VIAccountMO {

    @NSManaged var domain: String?
    @NSManaged var node: String?
    @NSManaged var chat: NSManagedObject?
    @NSManaged var client: NSManagedObject?
    @NSManaged var group: NSManagedObject?
    @NSManaged var resources: NSSet?

}
