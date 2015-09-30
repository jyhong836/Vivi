//
//  InputTextView.swift
//  Vivi
//
//  Created by Junyuan Hong on 9/4/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Cocoa

class InputTextView: NSTextView {
    
    // FIXME: file name may be conflicted.
    /// Files to be sent.
    var sendingFiles: [String] {
        get {
            var files = [String]()
            for attIdx in self.textStorage!.attachmentIndexs {
                let attachment = self.textStorage!.attachmentAtIndex(attIdx)!
                if let filecell = attachment.attachmentCell as? TextAttachmentFileCell {
                    files.append(filecell.fullFilename)
                }
            }
            return files
        }
    }

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }
    
    override func performDragOperation(sender: NSDraggingInfo) -> Bool {
        let pboard = sender.draggingPasteboard()
        if let pboardtypes = pboard.types {
            if pboardtypes.contains(NSFilenamesPboardType) {
                if let files = pboard.propertyListForType(NSFilenamesPboardType) as? [String] {
                    NSLog("\(files)")
                    for file in files {
                        appendFileAttachment(named: file)
                    }
                }
            }
        }
        
        return true
    }
    
    func appendFileAttachment(named name: String) {
        let attachment = NSTextAttachment()
        
        do {
            let fileWrapper = try NSFileWrapper(URL: NSURL(fileURLWithPath: name), options: NSFileWrapperReadingOptions.Immediate)
            let imgcell = TextAttachmentFileCell(fileWrapper: fileWrapper)
            imgcell.fullFilename = name
            attachment.attachmentCell = imgcell
            attachment.fileWrapper = fileWrapper
        } catch {
            fatalError("Fail to create file wrapper: \(error)")
        }
        
        let attriString = NSAttributedString(attachment: attachment)
        self.textStorage?.appendAttributedString(attriString)
    }
    
}
