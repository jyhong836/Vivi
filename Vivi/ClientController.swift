//
//  VSClientController.swift
//  Vivi
//
//  Created by Junyuan Hong on 7/22/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Cocoa
import ViviSwiften

class ClientController: NSObject, VSClientController, VSClientDelegate {
    var clientDelegate: VSClientDelegate?
    var accountName: String! = "jyhong@xmpp.jp"
    var accountPasswd: String! = "jyhong123"
    var client: SWClientAdapter!
    var eventLoop: SWEventLoop! // TODO: add access control to eventLoop
    
    override init() {
        super.init()
        clientDelegate = self
        eventLoop = SWEventLoop()
        client = SWClientAdapter(accountName,
            password: accountPasswd,
            eventLoop: eventLoop)
    }
    // MARK: VSClientDelegate protocol
    func clientDidConnect(client: SWClientAdapter!) {
        NSLog("Client connected [Swift]")
    }
    
    func clientDidReceiveMessage(client: SWClientAdapter!, fromAccount account: String!, inContent content: String!) {
        // TODO: removet the NSLog
        NSLog("from: \(account) content: \(content)");
    }
    
    // MARK: VSControllerProtocol
    
    func controllerDidLoad() {
        eventLoop.start()
    }
    
    func controllerWillClose() {
        
    }
}
