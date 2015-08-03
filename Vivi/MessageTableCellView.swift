//
//  MessageTableCellView.swift
//  Vivi
//
//  Created by Junyuan Hong on 8/2/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Cocoa

class MessageTableCellView: NSTableCellView {

    @IBOutlet weak var outBubleImageView: NSImageView!
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
////        self.textField?.setFrameSize(NSSize(width: CGFloat(160), height: CGFloat(17.0)))
//        if let tf = textField {
//            var oldFrameSize = tf.frame.size
//            var oldFrameOrigin = tf.frame.origin
//            var newWidth = oldFrameSize.width
//            var newHeight = oldFrameSize.height
////            var newWidth = 17*CGFloat((textField?.stringValue.lengthOfBytesUsingEncoding(NSString.defaultCStringEncoding()))!)
////            var newHeight = oldFrameSize.height
////            tf.setFrameOrigin(NSPoint(x: oldFrameOrigin.x + oldFrameSize.width - newWidth, y: oldFrameOrigin.y))
////            tf.setFrameSize(NSSize(width: newWidth, height: newHeight))
//            
//            oldFrameSize = outBubleImageView.frame.size
//            oldFrameOrigin = outBubleImageView.frame.origin
//            newWidth += 30
//            newHeight += 26.0 - 17.0
////            print("\(newWidth), \(newHeight)")
//            outBubleImageView.setFrameOrigin((NSPoint(x: oldFrameOrigin.x + oldFrameSize.width - newWidth, y: oldFrameOrigin.y + oldFrameSize.height - newHeight)))
//            outBubleImageView.setFrameSize(NSSize(width: newWidth, height: newHeight))
//        }
    }
    
}
