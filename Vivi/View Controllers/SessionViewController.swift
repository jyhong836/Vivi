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
    
    weak var clientViewController: ClientViewController?
    
    var currentClient: SWClient? = nil {
        didSet {
            clientViewController?.currentClient = currentClient
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
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
            let cell = tableView.makeViewWithIdentifier(col.identifier, owner: self) as! NSTableCellView
            if let c = currentClient {
                let chatListController = (c.chatListController as! VIChatListController)
                cell.textField?.stringValue = chatListController.getChatAtIndex(row)!.buddy.getAccountString()
            } else {
                cell.textField?.stringValue = "Unknown user"
            }
            return cell
        }
        return nil
    }
    
}
