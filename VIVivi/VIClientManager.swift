//
//  VIClientManager.swift
//  Vivi
//
//  Created by Junyuan Hong on 7/26/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Cocoa
import ViviSwiften

public class VIClientManager: VIClientManagerProtocol {
    var clientList: [SWClient!]! = []
    // FIXME: eventloop should be managed by VIClientManager?
    let eventLoop = SWEventLoop()
    
    public static let sharedClientManager: VIClientManager = {
        let instance = VIClientManager()
        // init code here
        return instance
        }()
    
    public func addClient(withClient client: SWClient) -> ClientIndex? {
        clientList.append(client)
        return clientList.indexOf({c in c == client})
    }
    
    public func addClient(withAccount account: SWAccount, andPasswd passwd: String!) -> ClientIndex? {
        return addClient(withClient: SWClient(account: account, password: passwd, eventLoop: eventLoop))
    }
    
    public func addClient(withAccountName account: String!, andPasswd passwd: String!) -> ClientIndex? {
        return addClient(withClient: SWClient(accountString: account, password: passwd, eventLoop: eventLoop))
    }
    
    public func removeClientAtIndex(index: ClientIndex?) {
        
    }
    
    public func removeClient(client: SWClient?) {
        
    }
    
    public func getClientAtIndex(index: ClientIndex?) -> SWClient? {
        if let i = index {
            if index >= 0 && index < clientList.count {
                return clientList[i]
            } else {
                return nil
            }
        }
        return nil
    }
    
    public func indexOfClient(client: SWClient?) -> ClientIndex? {
        return clientList.indexOf({c in c == client})
    }
    
    public func getClientCount() -> Int {
        return clientList.count
    }
    
    public var maxClientCount: Int {
        get {
            return 5
        }
    }
}
