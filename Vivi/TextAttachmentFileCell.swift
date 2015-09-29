//
//  TextAttachmentFileCell.swift
//  Vivi
//
//  Created by Junyuan Hong on 9/10/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Cocoa
import ViviSwiften
import ViviInterface

class TextAttachmentFileCell: NSTextAttachmentCell, VSFileTransferDelegate {
    
    var fullFilename = ""
    
    private var filenameAttributedString = NSAttributedString(string: "null")
    var filename: String {
        get {
            return filenameAttributedString.string
        }
        set {
            filenameAttributedString = NSAttributedString(string: newValue)
        }
    }
    private var filesizeAttributedString = NSAttributedString(string: "0 B")
    var filesizeString: String {
        get {
            return filesizeAttributedString.string
        }
        set {
            filesizeAttributedString = NSAttributedString(string: newValue)
        }
    }
    
    let stringHorizontalSpace = CGFloat(3)
    
    init(fileWrapper wrapper: NSFileWrapper) {
        super.init(imageCell: wrapper.icon!)//NSWorkspace.sharedWorkspace().iconForFile(wrapper.preferredFilename!))
        if !wrapper.regularFile {
            NSLog("WARN: not a regular file") // FIXEM: not a regular file
        }
        if let fsz = wrapper.fileAttributes["NSFileSize"] as? Int {
            let formatter = NSByteCountFormatter()
            filesizeString = formatter.stringFromByteCount(Int64(fsz))
        }
        filename = wrapper.preferredFilename!
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func drawWithFrame(cellFrame: NSRect, inView controlView: NSView?) {
        super.drawWithFrame(cellFrame, inView: controlView)
        
        filenameAttributedString.drawAtPoint(filenameBaselineOffsetAtRect(cellFrame))
        filesizeAttributedString.drawAtPoint(filesizeBaselineOffsetAtRect(cellFrame))
    }
    
    // MARK: - Geometry of cell
    
    override func cellSize() -> NSSize {
        var size = super.cellSize()
        
        let filenameSize = filenameAttributedString.size()
        size.height += filenameSize.height
        let filenameWidth = filenameSize.width
        if filenameWidth > size.width {
            size.width = filenameWidth
        }
        
        let filesizeSize = filenameAttributedString.size()
        size.height += filesizeSize.height
        let filesizeWidth = filesizeSize.width
        if filesizeWidth > size.width {
            size.width = filesizeWidth
        }
        
        size.width += stringHorizontalSpace * 2
        return size
    }
    
    override func cellBaselineOffset() -> NSPoint {
        var pt = super.cellBaselineOffset()
        pt.y += filenameAttributedString.size().height + filesizeAttributedString.size().height
        return pt
    }
    
    func filenameBaselineOffsetAtRect(rect: NSRect) -> NSPoint {
        let size = filenameAttributedString.size()
        return NSMakePoint(rect.origin.x + rect.width/2 - size.width/2, rect.origin.y + rect.height - filesizeAttributedString.size().height)
    }
    
    func filesizeBaselineOffsetAtRect(rect: NSRect) -> NSPoint {
        let size = filesizeAttributedString.size()
        return NSMakePoint(rect.origin.x + rect.width/2 - size.width/2, rect.origin.y + rect.height)
    }
    
    // MARK: - Conform to VSFileTransferDelegate protocol
    
    var attachmentMO: VIAttachmentMO?
    var fileTransfer: SWFileTransfer? {
        get {
            return attachmentMO?.fileTransfer
        }
    }
    
    /// Start file transfer
    var canStartTransfer = false
    
    func fileTransfer(filetransfer: SWFileTransfer!, processedBytes bytes: Int) {
        NSLog("attachment(\(filename) processed \(bytes) bytes)")
    }
    
    func fileTransfer(filetransfer: SWFileTransfer!, stateChanged stateCode: Int32) {
        NSLog("attachment(\(filename) state changed to \(stateCode)")
        attachmentMO?.state = NSNumber(int: stateCode)
    }
    
    func fileTransfer(filetransfer: SWFileTransfer!, finishedWithError errorCode: Int32) {
        NSLog("attachment(\(filename) failed with error \(errorCode)")
    }
}
