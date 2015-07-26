//
//  VIClientManager.swift
//  Vivi
//
//  Created by Junyuan Hong on 7/26/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Cocoa
import ViviSwiften

class ClientManager: VIClientManagerProtocol {
    var clientList: [SWClient!]! = []
    // FIXME: eventloop should be managed by ClientManager?
    let eventLoop = SWEventLoop()
    
    private static let sharedClientManager = ClientManager()
    
    private init() {
        // TODO: Add stored clients when inited
    }
    
    static func getShared() -> VIClientManagerProtocol {
        return sharedClientManager
    }
    
    func addClient(withClient client: SWClient) -> ClientIndex? {
        clientList.append(client)
        return clientList.indexOf({c in c == client})
    }
    
    func addClient(withAccount account: SWAccount, andPasswd passwd: String!) -> ClientIndex? {
        return addClient(withClient: SWClient(account: account, password: passwd, eventLoop: eventLoop))
    }
    
    func addClient(withAccountName account: String!, andPasswd passwd: String!) -> ClientIndex? {
        return addClient(withClient: SWClient(accountString: account, password: passwd, eventLoop: eventLoop))
    }
    
    func getClient(atIndex index: ClientIndex) -> SWClient? {
        if index >= 0 && index < clientList.count {
            return clientList[index]
        } else {
            return nil
        }
    }
    
    func indexOfClient(client: SWClient) -> ClientIndex? {
        return clientList.indexOf({c in c == client})
    }
}
