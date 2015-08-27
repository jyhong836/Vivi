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

class SessionViewController: NSViewController, NSTableViewDelegate {
    
    weak var managedObjectContext: NSManagedObjectContext! = {
        return VICoreDataController.shared.managedObjectContext
        }()

    @IBOutlet weak var sessionTableView: NSTableView!
    
//    var clientViewController: ClientViewController?
    
    var currentClient: SWClient? = nil {
        didSet {
//            clientViewController?.currentClient = currentClient
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
    
    // MARK: - Implementations for NSTableViewDelegate
    
    func tableView(tableView: NSTableView, selectionIndexesForProposedSelection proposedSelectionIndexes: NSIndexSet) -> NSIndexSet {
//        if proposedSelectionIndexes.count == 1 {
            // FIXME: ! Should use delegate to pass this message
            selectChatAtIndex(proposedSelectionIndexes.lastIndex)
//        }
        for index in proposedSelectionIndexes {
            let view = tableView.viewAtColumn(0, row: index, makeIfNecessary: false) as! SessionTableCellView
            view.switchSeperator()
        }
        return proposedSelectionIndexes
    }
    
    func selectChatAtIndex(index: Int) {
        // FIXME: should not use this to send select notification
        (currentClient?.managedObject as! VIClientMO).selectedChatIndex = index
    }
    
    // MARK: Button action
    
    @IBAction func addChatButtonClicked(sender: NSButton) {
        if let client = currentClient {
            let clientMO = client.managedObject as! VIClientMO
            clientMO.addTempChat()
            sessionTableView.selectRowIndexes(NSIndexSet(index: 0), byExtendingSelection: false)
            selectChatAtIndex(0)
        } else {
            // TODO: Let user to add a client.
            let question = NSLocalizedString("Could not add chat without client account", comment: "Add chat error question message")
            let info = NSLocalizedString("Without client, no message can be send", comment: "Add chat error question info")
            let configureButton = NSLocalizedString("Configure", comment: "Configure button title")
            let cancelButton = NSLocalizedString("Cancel", comment: "Cancel button title")
            let alert = NSAlert()
            alert.messageText = question
            alert.informativeText = info
            alert.addButtonWithTitle(configureButton)
            alert.addButtonWithTitle(cancelButton)
            
            let answer = alert.runModal()
            if answer == NSAlertFirstButtonReturn {
                // TODO: Configure new client
            }
//            else {
//                // Cancel
//            }
        }
    }
    
    let chatSortDescriptor = NSSortDescriptor(key: "updatedtime", ascending: false, selector: Selector("compare:"))
    var sortDescriptors: [NSSortDescriptor] {
        get {
            return [chatSortDescriptor]
        }
    }
    
    @IBAction func searchTextChanged(sender: NSSearchField) {
        let text = sender.stringValue
        
    }
    
    // MARK: - Handlers for chat update notification observers
    
    func newChatDidAdd(notification: NSNotification) {
//        let userInfo = notification.userInfo as! [String: AnyObject]
//        let index = userInfo["index"] as! Int
//        self.sessionTableView.insertRowsAtIndexes(NSIndexSet(index: index), withAnimation: NSTableViewAnimationOptions.SlideLeft)
    }
    
    func chatWillSendMessage(notification: NSNotification) {
//        let userInfo = notification.userInfo as! [String: AnyObject]
//        let oldIndex = userInfo["oldIndex"] as! Int
    }
    
    func chatDidSendMessage(notification: NSNotification) {
//        let userInfo = notification.userInfo as! [String: AnyObject]
//        let chatIndex = userInfo["chatIndex"] as! Int
//        self.sessionTableView.reloadDataForRowIndexes(NSIndexSet(index: chatIndex), columnIndexes: NSIndexSet(index: 0))
    }
    
    func chatDidReceiveMessage(notification: NSNotification) {
//        let userInfo = notification.userInfo as! [String: AnyObject]
//        let oldIndex = userInfo["oldIndex"] as! Int
    }
    
    @IBAction func chatDeleteButtonClicked(sender: NSButton) {
        let cellView = sender.superview as! SessionTableCellView
        let row = sessionTableView.rowForView(cellView)
        let clientMO = (currentClient?.managedObject as! VIClientMO)
        let chat = clientMO.chatAtIndex(row)
        VICoreDataController.shared.managedObjectContext.deleteObject(chat!)
//        sessionTableView.removeRowsAtIndexes(NSIndexSet(index: row), withAnimation: NSTableViewAnimationOptions.EffectFade)
    }
    
}
