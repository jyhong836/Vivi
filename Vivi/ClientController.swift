//
//  VSClientController.swift
//  Vivi
//
//  Created by Junyuan Hong on 7/22/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Cocoa
import ViviSwiften

// MARK: Swiften types
enum SWPresenceType: Int32 {
    case Available, Error, Probe, Subscribe, Subscribed, Unavailable, Unsubscribe, Unsubscribed
}
let SWPresenceTypeStringDict: [SWPresenceType: String] = [.Available: "Available", .Error: "Error", .Probe: "Probe", .Subscribe: "Subscribe", .Subscribed: "Subscribed", .Unavailable: "Unavailable", .Unsubscribe: "Unsubscribe", .Unsubscribed: "Unsubscribed"]
enum SWPresenceShowType: Int32 {
    case Online, Away, FFC, XA, DND, None
}
let SWPresenceShowTypeStringDict: [SWPresenceShowType: String] = [.Online: "Online", .Away: "Away", .FFC:"FFC", .XA: "XA", .DND: "DND", .None:"None"]

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
    
    func clientDidDisonnect(client: SWClientAdapter!, errorMessage errString: String!) {
        NSLog("Client disconnected with err:\(errString)[Swift]")
    }
    
    func clientDidReceiveMessage(client: SWClientAdapter!, fromAccount account: SWAccount!, inContent content: String!) {
        // TODO: removet the NSLog
        NSLog("msg from: \(account.getAccountString()) content: \(content) [Swift]")
    }
    
    func clientDidReceivePresence(client: SWClientAdapter!, fromAccount account: SWAccount!, currentPresence presenceType: Int32, currentShow show: Int32, currentStatus status: String!) {
        let typeStr = SWPresenceTypeStringDict[SWPresenceType(rawValue: presenceType)!]
        let showType = SWPresenceShowTypeStringDict[SWPresenceShowType(rawValue: show)!]
        NSLog("pres from: \(account.getAccountString()) presence: \(typeStr!) show: \(showType!) status: \(status!) [Swift]")
    }
    
    // MARK: VSControllerProtocol
    
    func controllerDidLoad() {
        eventLoop.start()
    }
    
    func controllerWillClose() {
        if client.isConnected {
            client.disconnect()
        }
    }
}
