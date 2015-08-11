//
//  Chat+CoreDataProperties.swift
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

public extension VIChatMO {

    @NSManaged var createdtime: NSDate?
    @NSManaged var buddy: VIAccountMO?
    @NSManaged var messages: NSOrderedSet?
    @NSManaged var owner: VIClientMO?

}
