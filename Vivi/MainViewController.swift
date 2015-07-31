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

class MainViewController: NSViewController, VSClientDelegate, VSXMPPRosterDelegate, VIChatDelegate {

    @IBOutlet weak var sesConView: NSView!
    @IBOutlet weak var sessionView: NSView!
    @IBOutlet weak var chatView: NSView!
//    @IBOutlet weak var tableView: NSTableView!
    
    weak var sessionViewController: SessionViewController?
    
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
        
        // TODO: remove test code with account
        do {
            if let c = try clientMgr.addClient(withAccountName: SWClientFactory.clientAccountString[0], andPasswd: SWClientFactory.clientPasswdString[0]) {
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
    
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SessionViewSegue" {
            sessionViewController = segue.destinationController as? SessionViewController
            sessionViewController?.currentClient = currentClient
        }
    }

    // MARK: IBAction
//    @IBAction func connectButton(sender: NSButton) {
//        if let c = currentClient {
//            c.connect()
//            NSLog("Client(\(c.account.getFullAccountString())) connecting")
//        }
//    }

    @IBAction func sendMessageButton(sender: NSButton) {
        // TODO: add send message code
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
        sessionViewController?.sessionTableView.reloadData()
    }
    
    func chatDidReceiveMessage(chat: VIChat) {
//        tableView.reloadDataForRowIndexes(<#T##rowIndexes: NSIndexSet##NSIndexSet#>, columnIndexes: 0)
    }
    
    func chatDidSendMessage(chat: VIChat) {
        //        tableView.reloadDataForRowIndexes(<#T##rowIndexes: NSIndexSet##NSIndexSet#>, columnIndexes: 0)
    }
}

