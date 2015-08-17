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
            NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
                self.sessionTableView.reloadData()
            }
        }
    }
        
    let notificationCenter = NSNotificationCenter.defaultCenter()
    let mainQueue = NSOperationQueue.mainQueue()
    // MARK: Notification observers
    var newChatObserver: NSObjectProtocol?
    var chatWillSendObserver: NSObjectProtocol?
    var chatDidSendObserver: NSObjectProtocol?
    var chatDidReceiveObserver: NSObjectProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear() {
        // set up notification ovbservers when view appears
        newChatObserver = notificationCenter.addObserverForName(VIClientChatDidAddNotification, object: nil, queue: mainQueue, usingBlock: newChatDidAdd)
        chatWillSendObserver = notificationCenter.addObserverForName(VIClientChatWillSendMsgNotification, object: nil, queue: mainQueue, usingBlock: chatWillSendMessage)
        chatDidSendObserver = notificationCenter.addObserverForName(VIClientChatDidSendMsgNotification, object: nil, queue: mainQueue, usingBlock: chatDidSendMessage)
        chatDidReceiveObserver = notificationCenter.addObserverForName(VIClientChatDidReceiveMsgNotification, object: nil, queue: mainQueue, usingBlock: chatDidReceiveMessage)
    }
    
    override func viewWillDisappear() {
        // clear notification ovbservers when view appears
        notificationCenter.removeObserver(newChatObserver!)
        notificationCenter.removeObserver(chatWillSendObserver!)
        notificationCenter.removeObserver(chatDidSendObserver!)
        notificationCenter.removeObserver(chatDidReceiveObserver!)
        newChatObserver = nil
        chatWillSendObserver = nil
        chatDidSendObserver = nil
        chatDidReceiveObserver = nil
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
            return (c.managedObject as! VIClientMO).chatCount
        } else {
            return 0
        }
    }
    
    // MARK: Implementations for NSTableViewDelegate
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let col = tableColumn {
            let cell = tableView.makeViewWithIdentifier(col.identifier, owner: self) as! SessionTableCellView
            if let c = currentClient {
                let clientMO = c.managedObject as! VIClientMO
                let chat = clientMO.chatAtIndex(row)!
                cell.textField?.stringValue = chat.buddy!.accountString
                cell.textField?.toolTip = cell.textField?.stringValue
                cell.lastMessageTextField.stringValue = chat.lastMessage
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
            (currentClient?.managedObject as! VIClientMO).selectedChatIndex = proposedSelectionIndexes.lastIndex
        }
        return proposedSelectionIndexes
    }
    
    // MARK: Handlers for chat update notification observers
    
    func newChatDidAdd(notification: NSNotification) {
        let userInfo = notification.userInfo as! [String: AnyObject]
        let index = userInfo["index"] as! Int
        self.sessionTableView.insertRowsAtIndexes(NSIndexSet(index: index), withAnimation: NSTableViewAnimationOptions.SlideLeft)
    }
    
    func chatWillSendMessage(notification: NSNotification) {
        let userInfo = notification.userInfo as! [String: AnyObject]
        let oldIndex = userInfo["oldIndex"] as! Int
        updateAndMoveCellAtIndex(oldIndex)
    }
    
    func chatDidSendMessage(notification: NSNotification) {
        let userInfo = notification.userInfo as! [String: AnyObject]
        let chatIndex = userInfo["chatIndex"] as! Int
        self.sessionTableView.reloadDataForRowIndexes(NSIndexSet(index: chatIndex), columnIndexes: NSIndexSet(index: 0))
    }
    
    func chatDidReceiveMessage(notification: NSNotification) {
        let userInfo = notification.userInfo as! [String: AnyObject]
        let oldIndex = userInfo["oldIndex"] as! Int
        updateAndMoveCellAtIndex(oldIndex)
    }
    
    /// Update cell at oldIndex. If index is -1, update cell at index 0.
    /// If index is 0, update it. If index is others, move to index 0, and
    /// update it.
    private func updateAndMoveCellAtIndex(oldIndex: Int) {
        if oldIndex > 0 {
            self.sessionTableView.moveRowAtIndex(oldIndex, toIndex: 0)
        }
        self.sessionTableView.reloadDataForRowIndexes(NSIndexSet(index: 0), columnIndexes: NSIndexSet(index: 0))
    }
    
}
