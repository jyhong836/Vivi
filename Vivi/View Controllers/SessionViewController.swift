//
//  ContactViewController.swift
//  Vivi
//
//  Created by Junyuan Hong on 7/31/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Cocoa
import ViviSwiften
import ViviInterface

class SessionViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    
    @IBOutlet weak var sessionTableView: NSTableView!
    
    var clientViewController: ClientViewController?
    
    var currentClient: SWClient? = nil {
        didSet {
            clientViewController?.currentClient = currentClient
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserverForName(
            VIChatListChatDidAddNotification,
            object: nil,
            queue: NSOperationQueue.mainQueue()) {
                (notification) -> Void in
                let userInfo = notification.userInfo as! [String: AnyObject]
                let index = userInfo["index"] as! Int
                self.sessionTableView.insertRowsAtIndexes(NSIndexSet(index: index), withAnimation: NSTableViewAnimationOptions.SlideLeft)
        }
    }
    
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ClientViewSegue" {
            clientViewController = segue.destinationController as? ClientViewController
            clientViewController?.currentClient = currentClient
        }
    }
    
    // MARK: Implementations for NSTableViewDataSource
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        if let c = currentClient {
            return (c.chatListController as! VIChatListController).chatCount
        } else {
            return 0
        }
    }
    
    // MARK: Implementations for NSTableViewDelegate
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let col = tableColumn {
            let cell = tableView.makeViewWithIdentifier(col.identifier, owner: self) as! SessionTableCellView
            if let c = currentClient {
                let chatListController = (c.chatListController as! VIChatListController)
                cell.textField?.stringValue = chatListController.chatAtIndex(row)!.buddy.getAccountString()
                cell.textField?.toolTip = cell.textField?.stringValue
                cell.lastMessageTextField.stringValue = (chatListController.chatAtIndex(row)!.lastMessage)
                cell.lastMessageTextField.toolTip = cell.lastMessageTextField.stringValue
            } else {
                cell.textField?.stringValue = "Unknown user"
            }
            return cell
        }
        return nil
    }
    
    func tableView(tableView: NSTableView, selectionIndexesForProposedSelection proposedSelectionIndexes: NSIndexSet) -> NSIndexSet {
        if proposedSelectionIndexes.count == 1 {
            // FIXME: ! Should use delegate to pass this message
            (currentClient?.chatListController as! VIChatListController).selectedChatIndex = proposedSelectionIndexes.lastIndex
        }
        return proposedSelectionIndexes
    }
    
    // MARK: API for chat update
    /// Called when any session is updated.
    func sessionDidUpdate() {
        // TODO: Add more process and seperate functions.
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.sessionTableView.reloadData()
        })
    }
    
}
