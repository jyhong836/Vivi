//
//  ChatMessageViewController.swift
//  Vivi
//
//  Created by Junyuan Hong on 8/2/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Cocoa
import ViviSwiften
import ViviInterface

class ChatMessageViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    
    weak var managedObjectContext: NSManagedObjectContext! = {
        return VICoreDataController.shared.managedObjectContext
        }()

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
    
    @IBAction func accountTextChanged(sender: NSTextField) {
        do {
            guard currentChat != nil else {
                fatalError("current chat should not be nil")
            }
            currentChat?.buddy = try VIAccountMO.addAccount(SWAccount(accountName: sender.stringValue), managedObjectContext: VICoreDataController.shared.managedObjectContext)
            updatePresence()
        } catch {
            let nserror = error as NSError
            let alert = NSAlert(error: nserror)
            alert.runModal()
        }
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
        let msg = (currentChat?.messageAtIndex(row))!
        let content = msg.content!
        let attributedContent = NSMutableAttributedString(string: content)
        do {
            // Search [file name] pattern
            let regexp = try NSRegularExpression(pattern: "\\[[^]]+\\]", options: NSRegularExpressionOptions(rawValue: 0))
            let contentRange = NSMakeRange(0, attributedContent.length)
            let matches = regexp.matchesInString(content, options: NSMatchingOptions(rawValue: 0), range: contentRange)
            for match in matches.reverse() {
                let range = match.range
                var bareRange = range
                bareRange.location += 1
                bareRange.length -= 2
                
                do {
                    // init file path
                    let filename = attributedContent.attributedSubstringFromRange(bareRange).string
                    let attachmentMO = msg.attachmentWithName(filename)
                    guard attachmentMO != nil else {
                        fatalError("Not found attachment with file name: \(filename)")
                    }
                    let fullFilename = attachmentMO!.filename!
                    let fileWrapper = try NSFileWrapper(URL: NSURL(fileURLWithPath: fullFilename), options: NSFileWrapperReadingOptions.Immediate) // .Immediate will cause error when file not exists.
                    
                    let attachment = NSTextAttachment()
                    let filecell = TextAttachmentFileCell(fileWrapper: fileWrapper)
                    attachmentMO!.fileTransfer!.delegate = filecell
                    filecell.attachmentMO = attachmentMO
                    attachment.attachmentCell = filecell
                    attachment.fileWrapper = fileWrapper
                    
                    attributedContent.replaceCharactersInRange(range, withAttributedString: NSAttributedString(attachment: attachment))
                } catch {
                    fatalError("Fail to create file wrapper: \(error)")
                }
            }
        } catch {
            fatalError("Fail to create regular expression: \(error)")
        }
        cell.textField?.attributedStringValue = attributedContent
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
                cell?.clearBadges()
                cell?.showFailBadge = false
            case .WillTo:
                cell = tableView.makeViewWithIdentifier("OutMessageCellView", owner: self) as? MessageTableCellView
                cell?.clearBadges()
                cell?.showSendingBadge = true
            case .FailTo:
                cell = tableView.makeViewWithIdentifier("OutMessageCellView", owner: self) as? MessageTableCellView
                cell?.clearBadges()
                cell?.showFailBadge = true
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
        chatDidUpdateMessageAtIndex(messageIndex)
        if let errcode = userInfo["error"] as? Int {
            let error = VSClientErrorType(rawValue: errcode)!
            switch (error) {
//            case .ClientUnavaliable:
//                let alert = NSAlert()
//                alert.messageText = "Please log in before sending message."
//                alert.runModal()
            case .Unknown:
                fallthrough
            default:
                NSLog("** Fail to send message: Unknown error")
            }
        }
    }
    
    func chatDidReceiveMessage(notification: NSNotification) {
        chatDidAddMessage()
    }
    
    /// Update buddyNameTextField and accountTextField. If Buddy 
    /// is nil, show "New Chat", and set accountTextField to editable.
    func updatePresence() {
        if let chat = self.currentChat {
            if let buddy = chat.buddy {
                let account = buddy.swaccount!
                self.buddyNameTextField.stringValue =
                "\(account.node)(\(buddy.presence.parseWithShow(buddy.presenceshow, andStatus: buddy.status)!))"
                self.accountTextField.stringValue = account.string
                accountTextField.editable = false
            } else {
                self.buddyNameTextField.stringValue = "New Chat"
                self.accountTextField.stringValue = "node@domain"
                accountTextField.editable = true
                accountTextField.window?.makeFirstResponder(accountTextField)
            }
        }
    }
}
