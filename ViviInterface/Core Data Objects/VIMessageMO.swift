//
//  Message.swift
//  Vivi
//
//  Created by Junyuan Hong on 8/11/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Foundation
import CoreData
import ViviSwiften

public class VIMessageMO: NSManagedObject {

    func setDirection(dir: VIChatMessageDirection) {
        self.direction = NSNumber(integer: dir.rawValue)
    }
    
    func addAttachments(fileTransfers: [SWFileTransfer]?) {
        let moc = self.managedObjectContext
        if fileTransfers != nil {
            for fileTransfer in fileTransfers! {
                let attachment = NSEntityDescription.insertNewObjectForEntityForName("Attachment", inManagedObjectContext: moc!) as! VIAttachmentMO
                attachment.fileTransfer = fileTransfer
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
