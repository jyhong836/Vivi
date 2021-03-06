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

protocol SessionViewControllerDelegate {
    func chatIsSelected(chat: VIChatMO)
}

class SessionViewController: NSViewController, NSTableViewDelegate {
    
    weak var managedObjectContext: NSManagedObjectContext! = {
        return VICoreDataController.shared.managedObjectContext
        }()
    
    var delegate: SessionViewControllerDelegate?

    @IBOutlet weak var sessionTableView: NSTableView!
    @IBOutlet var chatArrayController: NSArrayController!
    
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
    
    func selectionShouldChangeInTableView(tableView: NSTableView) -> Bool {
        if let chat = chatArrayController.selectedObjects.last as? VIChatMO {
            chat.isRepresented = false
        }
        return true
    }
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        if let chat = chatArrayController.selectedObjects.last as? VIChatMO {
            didSelectChat(chat)
        }
    }
    
    func didSelectChat(chat: VIChatMO) {
        chat.isRepresented = true
        delegate?.chatIsSelected(chat)
    }
    
    // MARK: Button action
    
    @IBAction func addChatButtonClicked(sender: NSButton) {
        if let client = currentClient {
            let clientMO = client.managedObject as! VIClientMO
            sessionTableView.insertRowsAtIndexes(NSIndexSet(index: 0), withAnimation: NSTableViewAnimationOptions.EffectFade)
            let tempChat = clientMO.addTempChat()
            chatArrayController.addObject(tempChat)
            didSelectChat(tempChat)
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
    
    @IBAction func chatDeleteButtonClicked(sender: NSButton) {
        let cellView = sender.superview as! SessionTableCellView
        let row = sessionTableView.rowForView(cellView)
        if row == -1 {
            fatalError("unknown error: attempt to delete not existed row")
        }
        let clientMO = (currentClient?.managedObject as! VIClientMO)
        let chat = clientMO.chatAtIndex(row)
        sessionTableView.removeRowsAtIndexes(NSIndexSet(index: row), withAnimation: NSTableViewAnimationOptions.EffectFade)
        chatArrayController.removeObject(chat!)
    }
    
    let chatSortDescriptor = NSSortDescriptor(key: "updatedtime", ascending: false, selector: Selector("compare:"))
    var sortDescriptors: [NSSortDescriptor] {
        get {
            return [chatSortDescriptor]
        }
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
    
}
