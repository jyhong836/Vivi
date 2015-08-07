//
//  ViewController.swift
//  Vivi
//
//  Created by Junyuan Hong on 7/21/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Cocoa
import ViviSwiften
import ViviInterface

class MainViewController: NSViewController, VSClientDelegate, VSXMPPRosterDelegate, VIChatDelegate, VIClientManagerDelegate {

    @IBOutlet weak var sesConView: NSView!
    @IBOutlet weak var sessionView: NSView!
    @IBOutlet weak var chatView: NSView!
//    @IBOutlet weak var tableView: NSTableView!
    
    weak var sessionViewController: SessionViewController?
    weak var chatViewController: ChatViewController?
    
    let clientMgr = VIClientManager.sharedClientManager
    var clients: [SWClient] = []
    var currentClient: SWClient? = nil {
        didSet {
            sessionViewController?.currentClient = currentClient
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        clientMgr.delegate = self
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "SessionViewSegue":
                sessionViewController = segue.destinationController as? SessionViewController
                sessionViewController?.currentClient = currentClient
            case "ChatViewSegue":
                chatViewController = segue.destinationController as? ChatViewController
                chatViewController?.currentClient = currentClient
            default: break
            }
        }
    }
    
    // MARK: Implementations for VSClientDelegate
    
    func clientDidConnect(client: SWClient!) {
        NSLog("client(\(client.account.getFullAccountString())) did connect")
    }
    
    func clientDidDisconnect(client: SWClient!, errorCode code: Int32) {
        NSLog("client(\(client.account.getFullAccountString())) did disconnect")
    }
    
    func clientDidReceivePresence(client: SWClient!, fromAccount account: SWAccount!, currentPresence presenceType: Int32, currentShow show: Int32, currentStatus status: String!) {
        NSLog("client(\(client.account.getFullAccountString())) did receive presence from \(account.getFullAccountString())")
    }
    
    func clientDidReceiveMessage(client: SWClient!, fromAccount account: SWAccount!, inContent content: String!) {
        NSLog("client(\(client.account.getFullAccountString())) did receive message from \(account.getFullAccountString()): \(content)")
    }
    
    // MARK: Implementations for VSXMPPRosterDelegate
    
    func rosterDidInitialize() {
        currentClient?.roster.printItems()
    }
    
    // MARK: Implementations for VIChatDelegate
    
    func chatWillStart(chat: VIChat) {
        sessionViewController?.sessionDidUpdate()
        chatViewController?.chatDidUpdate(chat)
    }
    
    func chatDidReceiveMessage(chat: VIChat) {
        sessionViewController?.sessionDidUpdate()
        chatViewController?.chatDidUpdate(chat)
//        tableView.reloadDataForRowIndexes(<#T##rowIndexes: NSIndexSet##NSIndexSet#>, columnIndexes: 0)
    }
    
    // TODO: Wrap the three delegate into one?
    func chatWillSendMessage(chat: VIChat, updatedIndex index: Int) {
        sessionViewController?.sessionDidUpdate()
        chatViewController?.chatDidUpdate(chat, updateMessageAtIndex: index)
    }
    
    func chatDidSendMessage(chat: VIChat, updatedIndex index: Int) {
        sessionViewController?.sessionDidUpdate()
        chatViewController?.chatDidUpdate(chat, updateMessageAtIndex: index)
    }
    
    func chatFailSendMessage(chat: VIChat, updatedIndex index: Int, error: VSClientErrorType) {
        sessionViewController?.sessionDidUpdate()
        chatViewController?.chatDidUpdate(chat, updateMessageAtIndex: index)
    }
    
    func chatIsSelected(chat: VIChat) {
        chatViewController?.currentChat = chat
        chatViewController?.view.hidden = false
    }
    
    // MARK: Implement VIClientManagerDelegate
    func managerDidAddClient(client: SWClient?) {
        // FIXME: The new client should not be the currentClient in multi-client situation.
        if let c = client {
            clients.append(c)
            currentClient = c
            
            c.delegate = self
            c.roster.delegate = self
            (c.chatListController as! VIChatListController).chatDelegate = self
            if let infoDict = NSBundle.mainBundle().localizedInfoDictionary {
                let appName = infoDict[String(kCFBundleNameKey)] as! String
                let appVer = infoDict[String(kCFBundleVersionKey)] as! String
                c.setSoftwareName(appName, currentVersion: appVer)
            }
            
            // TODO: remove test code
            (c.chatListController as! VIChatListController).addChatWithBuddy(SWAccount(accountName: "jyhong1@xmpp.jp"))
            
            sessionViewController?.currentClient = c
            chatViewController?.currentClient = c
        }
    }
    
    func managerDidRemoveClient(client: SWClient?) {
        // TODO: test remove client, and remove from subview controllers.
        if client != nil && currentClient == client {
            currentClient = nil
            sessionViewController?.currentClient = nil
            chatViewController?.currentClient = nil
        }
    }
}

