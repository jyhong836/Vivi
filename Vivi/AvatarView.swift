//
//  AvatarView.swift
//  Vivi
//
//  Created by Junyuan Hong on 8/28/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Cocoa

class AvatarView: NSImageView {

    override func drawRect(dirtyRect: NSRect) {
        let rect = self.bounds
        let gap = CGFloat(4)
        let newRect = NSMakeRect(rect.origin.x+gap/2, rect.origin.y+gap/2, rect.width-gap, rect.height-gap)
        let path = NSBezierPath(roundedRect: newRect, xRadius: newRect.size.width/2.0, yRadius: newRect.size.height/2.0)
        path.setClip()
        
        super.drawRect(dirtyRect)
    }
    
}
