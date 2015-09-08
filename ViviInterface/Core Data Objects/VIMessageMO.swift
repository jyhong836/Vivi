//
//  Message.swift
//  Vivi
//
//  Created by Junyuan Hong on 8/11/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Foundation
import CoreData

public class VIMessageMO: NSManagedObject {

    func setDirection(dir: VIChatMessageDirection) {
        self.direction = NSNumber(integer: dir.rawValue)
    }
    
    func addAttachments(filenames: [String]?) {
        let moc = self.managedObjectContext
        if filenames != nil {
            for filename in filenames! {
                let attachment = NSEntityDescription.insertNewObjectForEntityForName("Attachment", inManagedObjectContext: moc!) as! VIAttachmentMO
                attachment.filename = filename
                attachment.message = self
            }
        }
    }
    
}
