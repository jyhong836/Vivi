//
//  SessionTableCellView.swift
//  Vivi
//
//  Created by Junyuan Hong on 8/1/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Cocoa

class SessionTableCellView: NSTableCellView {
    
    @IBOutlet weak var lastMessageTextField: NSTextField!
    
    @IBOutlet weak var avaterImageView: NSImageView!
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }
    
}
