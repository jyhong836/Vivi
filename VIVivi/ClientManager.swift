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
    
    static let sharedClientManager: ClientManager = {
        let instance = ClientManager()
        // init code here
        return instance
        }()
    
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
    
    func removeClientAtIndex(index: ClientIndex?) {
        
    }
    
    func removeClient(client: SWClient?) {
        
    }
    
    func getClientAtIndex(index: ClientIndex?) -> SWClient? {
        if let i = index {
            if index >= 0 && index < clientList.count {
                return clientList[i]
            } else {
                return nil
            }
        }
        return nil
    }
    
    func indexOfClient(client: SWClient?) -> ClientIndex? {
        return clientList.indexOf({c in c == client})
    }
    
    func getClientCount() -> Int {
        return clientList.count
    }
    
    var maxClientCount: Int {
        get {
            return 5
        }
    }
}
