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
    
    func applicationWillFinishLaunching(notification: NSNotification) {
        
        VIClientManager.sharedClientManager.startClientLoop()
        
        let clientMgr = VIClientManager.sharedClientManager
        clientMgr.loadFromEnities()
        
        // init unread count
        updateDockBadge()
        clientMgr.addUnreadCountObservers(self)
    }

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    // MARK: Reopen window when active dock
    
    func applicationShouldHandleReopen(sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !flag {
            for window in sender.windows {
                window.makeKeyAndOrderFront(self)
            }
        }
        return true
    }
    
    // MARK: - Core Data stack
    
    lazy var coreDataController = VICoreDataController.shared
    
    // MARK: Core Data Saving and Undo support
    
    @IBAction func saveAction(sender: AnyObject!) {
        coreDataController.saveAction(sender)
    }
    
    func windowWillReturnUndoManager(window: NSWindow) -> NSUndoManager? {
        // Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
        return coreDataController.windowWillReturnUndoManager(window)
    }
    
    func applicationShouldTerminate(sender: NSApplication) -> NSApplicationTerminateReply {
        // Save changes in the application's managed object context before the application terminates.
        return coreDataController.applicationShouldTerminate(sender)
    }
    
    // MARK: Update ui
    
    /// Update dock tile badge with unread message count. This function will
    /// recaculate the unread count.
    func updateDockBadge() {
        let dockTile = NSApplication.sharedApplication().dockTile
        let unreadCount = VIClientManager.sharedClientManager.unreadCount
        if unreadCount > 0 {
            dockTile.badgeLabel = String(unreadCount)
        } else {
            dockTile.badgeLabel = nil
        }
    }
    
    func addDockBadgeCount() {
        let dockTile = NSApplication.sharedApplication().dockTile
        if let label = dockTile.badgeLabel {
            let unreadCount = Int(label)! + 1
            if unreadCount > 0 {
                dockTile.badgeLabel = String(unreadCount)
            }
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if object is VIClientMO && keyPath == "unreadcount" {
            updateDockBadge()
        }
    }
}

