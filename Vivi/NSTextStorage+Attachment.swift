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
                    }
                    index = effectiveRange.location + effectiveRange.length
                } while (index < strRange.length)
            }
            
            return attachments
        }
    }
    
}
