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

class ViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource, VSClientDelegate, VSXMPPRosterDelegate, VIChatDelegate {
    
    @IBOutlet weak var messageTextField: NSScrollView!
    @IBOutlet weak var connectButton: NSButton!

    @IBOutlet weak var tableView: NSTableView!
    
    let clientMgr = VIClientManager.sharedClientManager
    var clients: [SWClient] = []
    weak var currentClient: SWClient? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.reloadData()
        
        // TODO: remove test code with account
        do {
            if let c = try clientMgr.addClient(withAccountName: "jyhong@xmpp.jp/Vivi", andPasswd: "jyhong123") {
                clientMgr.startClientLoop()
                clients.append(c)
                currentClient = c
                c.delegate = self
                c.roster.delegate = self
                (c.chatListController as! VIChatListController).chatDelegate = self
            }
        } catch {
            NSLog("Unexpected error")
        }
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    // MARK: IBAction
    @IBAction func connectButton(sender: NSButton) {
        if let c = currentClient {
            c.connect()
            NSLog("Client(\(c.account.getFullAccountString())) connecting")
        }
    }

    @IBAction func sendMessageButton(sender: NSButton) {
        // TODO: add send message code
    }
    
    // MARK: Implementations for NSTableViewDataSource
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        if let c = currentClient {
            return (c.chatListController as! VIChatListController).chatList.count
        } else {
            return 0
        }
    }
    
    // MARK: Implementations for NSTableViewDelegate
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let col = tableColumn {
            let cell = tableView.makeViewWithIdentifier(col.identifier, owner: self) as! NSTableCellView
            if let c = currentClient {
                let chatList = (c.chatListController as! VIChatListController).chatList
                cell.textField?.stringValue = chatList[row].buddy.getAccountString()
            } else {
                cell.textField?.stringValue = "Unknown user"
            }
            return cell
        }
        return nil
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
        tableView.reloadData()
    }
    
    func chatDidReceiveMessage(chat: VIChat) {
//        tableView.reloadDataForRowIndexes(<#T##rowIndexes: NSIndexSet##NSIndexSet#>, columnIndexes: 0)
    }
    
    func chatDidSendMessage(chat: VIChat) {
        //        tableView.reloadDataForRowIndexes(<#T##rowIndexes: NSIndexSet##NSIndexSet#>, columnIndexes: 0)
    }
}

