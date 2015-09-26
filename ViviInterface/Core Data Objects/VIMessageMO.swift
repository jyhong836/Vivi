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
    
    // TODO: handle the confilcted filename
    public func attachmentWithName(filename: String) -> VIAttachmentMO? {
        for att in attachments! {
            if let a = att as? VIAttachmentMO {
                do {
                    let fw = try NSFileWrapper(URL: NSURL(fileURLWithPath: a.filename!), options: NSFileWrapperReadingOptions.Immediate)
                    if a.filename == filename || fw.preferredFilename == filename {
                        return a
                    }
                } catch {
                    fatalError("Fail to create file wrapper: \(error)")
                }
            }
        }
        return nil
    }
    
}
