//
//  MainWindowController.swift
//  Vivi
//
//  Created by Junyuan Hong on 8/4/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        window?.titlebarAppearsTransparent = true
        window!.title = ""
//        window?.titleVisibility = NSWindowTitleVisibility.Hidden
//        window?.movableByWindowBackground = true
//        window?.movable = true
    }

}
