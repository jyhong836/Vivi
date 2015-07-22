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
    var accountName: String!
    var accountPasswd: String!
    var client: SWClientAdapter!
    
    override init() {
        super.init()
        clientDelegate = self
        client = SWClientAdapter()
    }
    // MARK: VSClientDelegate protocol
    func clientDidConnect(clientController: VSClientController!) {
        NSLog("Client connected [Swift]")
    }
    
    // MARK: VSControllerProtocol
    
    func controllerDidLoad() {
        client.runBackgroud()
    }
    
    func controllerWillClose() {
        
    }
}
