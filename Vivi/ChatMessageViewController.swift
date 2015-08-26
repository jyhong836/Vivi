//
//  ChatMessageViewController.swift
//  Vivi
//
//  Created by Junyuan Hong on 8/2/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Cocoa
import ViviInterface

class ChatMessageViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

    @IBOutlet weak var buddyNameTextField: NSTextField!
    @IBOutlet weak var accountTextField: NSTextField!
    @IBOutlet weak var messageTableView: NSTableView!
    
    var currentChat: VIChatMO? {
        didSet {
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.removeChatObservers()
                self.addChatObservers()
                self.updatePresence()
                self.messageTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    // MARK: Notification configures
    
    let notificationCenter = NSNotificationCenter.defaultCenter()
    let mainQueue = NSOperationQueue.mainQueue()
    
    var chatWillSendObserver: NSObjectProtocol?
    var chatDidSendObserver: NSObjectProtocol?
    var chatDidReceiveObserver: NSObjectProtocol?
    var didReceivePresenceObserver: NSObjectProtocol?
    
    override func viewWillAppear() {
        addChatObservers()
    }
    
    override func viewWillDisappear() {
        removeChatObservers()
    }
    
    func addChatObservers() {
        chatWillSendObserver = notificationCenter.addObserverForName(VIClientChatWillSendMsgNotification, object: currentChat, queue: mainQueue, usingBlock: chatWillSendMessage)
        chatDidSendObserver = notificationCenter.addObserverForName(VIClientChatDidSendMsgNotification, object: currentChat, queue: mainQueue, usingBlock: chatDidSendMessage)
        chatDidReceiveObserver = notificationCenter.addObserverForName(VIClientChatDidReceiveMsgNotification, object: currentChat, queue: mainQueue, usingBlock: chatDidReceiveMessage)
        didReceivePresenceObserver = notificationCenter.addObserverForName(VIClientDidReceivePresence, object: currentChat?.buddy, queue: mainQueue, usingBlock: { (notification) -> Void in
            self.updatePresence()
        })
    }
    
    func removeChatObservers() {
        notificationCenter.removeObserver(chatWillSendObserver!)
        notificationCenter.removeObserver(chatDidSendObserver!)
        notificationCenter.removeObserver(chatDidReceiveObserver!)
        chatWillSendObserver = nil
        chatDidSendObserver = nil
        chatDidReceiveObserver = nil
    }
    
    // MARK: API for update chat table view
    /// Call when chat did update message at index. This will only reload one message cell view.
    private func chatDidUpdateMessageAtIndex(index: Int) {
        if currentChat != nil {
            self.messageTableView.reloadDataForRowIndexes(NSIndexSet(index: index), columnIndexes: NSIndexSet(index: 0))
        } else {
            assert(false, "Attempt to update an chat when currentChat is not set up")
        }
    }
    
    /// Call when chat add one message, this will update chat table view.
    private func chatDidAddMessage() {
        if currentChat != nil {
//                self.messageTableView.beginUpdates()
            self.messageTableView.insertRowsAtIndexes(NSIndexSet(index: self.messageTableView.numberOfRows), withAnimation: NSTableViewAnimationOptions.EffectNone)
//                self.messageTableView.endUpdates()
            self.messageTableView.noteHeightOfRowsWithIndexesChanged(NSIndexSet(index: self.messageTableView.numberOfRows - 1))
            self.messageTableView.scrollRowToVisible(self.messageTableView.numberOfRows - 1)
        } else {
            assert(false, "Attempt to update an chat when currentChat is not set up")
        }
    }
    
    // MARK: Implementations for NSTableViewDataSource
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        if let chat = currentChat {
            return chat.messageCount
        } else {
            return 0
        }
    }
    
    // MARK: Implementations for NSTableViewDelegate
    
    func configureCell(cell: MessageTableCellView, row: Int) -> MessageTableCellView {
        cell.textField?.stringValue = (currentChat?.messageAtIndex(row)?.content)!
        return cell
    }
    
    func messageCellViewForDir(dir: VIChatMessageDirection?, inTableView tableView: NSTableView) -> MessageTableCellView? {
        var cell: MessageTableCellView? = nil
        if let _dir = dir {
            switch _dir {
            case .From:
                cell = tableView.makeViewWithIdentifier("InMessageCellView", owner: self) as? MessageTableCellView
            case .To:
                cell = tableView.makeViewWithIdentifier("OutMessageCellView", owner: self) as? MessageTableCellView
            case .WillTo: // TODO: add "will to" processing
                cell = tableView.makeViewWithIdentifier("OutMessageCellView", owner: self) as? MessageTableCellView
            case .FailTo: // TODO: add "fail to" processing
                cell = tableView.makeViewWithIdentifier("OutMessageCellView", owner: self) as? MessageTableCellView
            default:
                break
            }
        }
        return cell
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var cell: MessageTableCellView? = messageCellViewForDir(directionOfRow(row), inTableView: tableView)
        if let cl = cell {
            cell = configureCell(cl, row: row)
        }
        return cell
    }
    
    func tableView(tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        return true
    }
    
    let defaultRowHeight = CGFloat(36)
    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        var cell: MessageTableCellView? = messageCellViewForDir(directionOfRow(row), inTableView: tableView)
        if let cl = cell {
            cell = configureCell(cl, row: row)
            cell!.layoutSubtreeIfNeeded()
            return cell!.frame.height
        }
        return defaultRowHeight
    }
    
    private func directionOfRow(row: Int) -> VIChatMessageDirection {
        return VIChatMessageDirection(rawValue: (currentChat?.messageAtIndex(row)?.direction?.integerValue)!)!
    }
    
    // MARK: Notification receivers
    
    func chatWillSendMessage(notification: NSNotification) {
        chatDidAddMessage()
    }
    
    func chatDidSendMessage(notification: NSNotification) {
        let userInfo = notification.userInfo as! [String: AnyObject]
        let messageIndex = userInfo["messageIndex"] as! Int
        // TODO: Process the send error
//        let error = userInfo["error"] as! Int
        chatDidUpdateMessageAtIndex(messageIndex)
    }
    
    func chatDidReceiveMessage(notification: NSNotification) {
        chatDidAddMessage()
    }
    
    func updatePresence() {
        if let chat = self.currentChat {
            if let buddy = chat.buddy {
                let account = buddy.swaccount!
                self.buddyNameTextField.stringValue =
                "\(account.getNodeString())(\(buddy.presence.parseWithShow(buddy.presenceshow, andStatus: buddy.status)!))"
                self.accountTextField.stringValue = account.getAccountString()
//                accountTextField.editable = false
            } else {
                self.buddyNameTextField.stringValue =
                "New Chat"
                self.accountTextField.stringValue = "node@domain"
//                accountTextField.editable = true
            }
        }
    }
}
