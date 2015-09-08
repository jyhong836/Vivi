//
//  VIAttachmentMO+CoreDataProperties.swift
//  Vivi
//
//  Created by Junyuan Hong on 9/8/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

public extension VIAttachmentMO {

    @NSManaged var filename: String?
    @NSManaged var state: NSNumber?
    @NSManaged var message: VIMessageMO?

}
