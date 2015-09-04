//
//  NSTextStorage+Attachment.swift
//  Vivi
//
//  Created by Junyuan Hong on 9/3/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Cocoa

extension NSTextStorage {

    var attachments: [NSTextAttachment] {
        get {
            var attachments: [NSTextAttachment] = []
            
            let strRange = NSMakeRange(0, self.length)
            if strRange.length > 0 {
                var index = 0
                repeat {
                    var effectiveRange = NSRange()
                    let attributes = self.attributesAtIndex(index, longestEffectiveRange: &effectiveRange, inRange: strRange)
                    if let attachment = attributes[NSAttachmentAttributeName] as? NSTextAttachment {
                        attachments.append(attachment)
                        self.replaceCharactersInRange(effectiveRange, withAttributedString: NSAttributedString(string: "[\(attachment.fileWrapper!.preferredFilename)]"))
                    }
                    index = effectiveRange.location + effectiveRange.length
                } while (index < strRange.length)
            }
            
            return attachments
        }
    }
    
    /// Transfer string stored with attachments. All attachments will be
    /// transfered to format like "[filepath]".
    func transferStringWithAttachments() -> String {
        let strRange = NSMakeRange(0, self.length)
        if strRange.length > 0 {
            var index = 0
            repeat {
                var effectiveRange = NSRange()
                let attributes = self.attributesAtIndex(index, longestEffectiveRange: &effectiveRange, inRange: strRange)
                if let attachment = attributes[NSAttachmentAttributeName] as? NSTextAttachment {
                    guard attachment.fileWrapper != nil else {
                        fatalError("not found fileWrapper in attachment")
                    }
                    guard attachment.fileWrapper!.preferredFilename != nil else {
                        fatalError("not found preferredFilename in attachment.fileWrapper")
                    }
                    self.replaceCharactersInRange(effectiveRange, withAttributedString: NSAttributedString(string: "[\(attachment.fileWrapper!.preferredFilename!)]"))
                }
                index = effectiveRange.location + effectiveRange.length
            } while (index < strRange.length)
        }
        
        return self.string
    }
    
}
