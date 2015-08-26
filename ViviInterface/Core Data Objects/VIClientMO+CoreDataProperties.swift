//
//  Client+CoreDataProperties.swift
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

public extension VIClientMO {
    
    @NSManaged var accountname: String?
    @NSManaged var hostname: String?
    @NSManaged var password: String?
    @NSManaged var port: NSNumber?
    @NSManaged var enabled: NSNumber?
    @NSManaged var canbeinvisible: NSNumber?
    @NSManaged var chats: NSOrderedSet?
    @NSManaged var roster: VIRosterMO?

}
