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

class ViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource, VSClientDelegate {
    
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
            if let c = try clientMgr.addClient(withAccountName: "jyhong@xmpp.jp", andPasswd: "jyhong123") {
                clientMgr.startClientLoop()
                clients.append(c)
                currentClient = c
                c.delegate = self
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
        return 2
    }
    
    // MARK: Implementations for NSTableViewDelegate
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let col = tableColumn {
            let cell = tableView.makeViewWithIdentifier(col.identifier, owner: self) as! NSTableCellView
            cell.textField?.stringValue = "hi"
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
}

