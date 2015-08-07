//
//  AppDelegate.swift
//  Vivi
//
//  Created by Junyuan Hong on 7/21/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Cocoa
import ViviInterface
import ViviSwiften

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let defaults = NSUserDefaults.standardUserDefaults()

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        defaults.registerDefaults(VIClientManager.sharedClientManager.clientManagerDefaults)
        VIClientManager.sharedClientManager.startClientLoop()
        
        let defaultClientEnabled = defaults.objectForKey("enabled") as! Int
        if defaultClientEnabled == NSOnState {
            VIClientManager.sharedClientManager.loadFromDefaults(defaults)
        }
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
}

