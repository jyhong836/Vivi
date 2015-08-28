//
//  VIAccountMO+CoreDataProperties.swift
//  Vivi
//
//  Created by Junyuan Hong on 8/28/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension VIAccountMO {

    @NSManaged var domain: String?
    @NSManaged var node: String?
    @NSManaged var avatar: NSData?
    @NSManaged var chat: VIChatMO?
    @NSManaged var groups: NSSet?
    @NSManaged var resources: NSSet?

}
