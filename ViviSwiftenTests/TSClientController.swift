//
//  TSClientController.swift
//  Vivi
//
//  Created by Junyuan Hong on 7/23/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import XCTest
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

class TSClientController: NSObject, VSClientController, VSClientDelegate {
    var clientDelegate: VSClientDelegate?
    var accountName: String! = "jyhong@xmpp.jp"
    var accountPasswd: String! = "jyhong123"
    var client: SWClient!
    var eventLoop: SWEventLoop! // TODO: add access control to eventLoop
    
    override init() {
        super.init()
        clientDelegate = self
        eventLoop = SWEventLoop()
        client = SWClient(accountName,
            password: accountPasswd,
            eventLoop: eventLoop)
    }
    
    // MARK: For test
    private var connectHandler: (()->Void)? = nil
    func connectWithHandler(connectHandler: ()->Void) {
        self.connectHandler = connectHandler;
        client.connect()
    }
    
    // MARK: VSClientDelegate protocol
    
    func clientDidConnect(client: SWClient!) {
        NSLog("Client connected [Swift]")
        if let conHandler = connectHandler {
            conHandler()
        }
    }
    
    func clientDidDisonnect(client: SWClient!, errorMessage errString: String!) {
//        if errString != nil && errString != "" {
//            XCTFail("Client disconnected with err:\(errString)")
//            if let clientEXC = clientTestExectiation {
//                clientEXC.fulfill()
//            }
//        }
    }
    
    func clientDidReceiveMessage(client: SWClient!, fromAccount account: SWAccount!, inContent content: String!) {
        NSLog("msg from: \(account.getAccountString()) content: \(content) [Swift]")
        XCTAssert(true)
        if let clientEXC = clientTestExectiation {
            clientEXC.fulfill()
        }
    }
    
    func clientDidReceivePresence(client: SWClient!, fromAccount account: SWAccount!, currentPresence presenceType: Int32, currentShow show: Int32, currentStatus status: String!) {
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
