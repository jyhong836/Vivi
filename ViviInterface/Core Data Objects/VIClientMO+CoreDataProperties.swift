//
//  VIClientMO+CoreDataProperties.swift
//  Vivi
//
//  Created by Junyuan Hong on 8/30/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

public extension VIClientMO {

    @NSManaged var accountname: String?
    @NSManaged var accdescription: String?
    @NSManaged var nickname: String?
    @NSManaged var canbeinvisible: NSNumber?
    @NSManaged var enabled: NSNumber?
    @NSManaged var hostname: String?
    @NSManaged var password: String?
    @NSManaged var port: NSNumber?
    @NSManaged var unreadcount: NSNumber?
    @NSManaged var resource: String?
    @NSManaged var priority: NSNumber?
    @NSManaged var chats: NSOrderedSet?
    @NSManaged var roster: VIRosterMO?

}
