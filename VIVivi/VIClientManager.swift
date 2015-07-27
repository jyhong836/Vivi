//
//  VIClientManager.swift
//  Vivi
//
//  Created by Junyuan Hong on 7/26/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Cocoa
import ViviSwiften

public enum VIClientManagerError: ErrorType {
    case AccountNameConfilct
}

public class VIClientManager: VIClientManagerProtocol {
    private var clientList: [SWClient]! = []
    // FIXME: eventloop should be managed by VIClientManager?
    private let eventLoop = SWEventLoop()
    
    public static let sharedClientManager: VIClientManager = {
        let instance = VIClientManager()
        // init code here
        return instance
        }()
    
    public func addClient(withAccount account: SWAccount, andPasswd passwd: String!) throws -> SWClient? {
        let newClient = SWClient(account: account, password: passwd, eventLoop: eventLoop)
        guard !clientList.contains( { (c: SWClient) -> Bool in
            c.account.getAccountString() == account.getAccountString()
        }) else {
            throw VIClientManagerError.AccountNameConfilct
        }
        clientList.append(newClient)
        return newClient
    }
    
    public func addClient(withAccountName account: String!, andPasswd passwd: String!) throws -> SWClient? {
        return try self.addClient(withAccount: SWAccount(account), andPasswd: passwd)
    }
    
    public func removeClient(client: SWClient?) {
        
    }
    
    public func removeAllClient() {
        clientList.removeAll(keepCapacity: true)
    }
    
    public func getClient(withAccountName name: String) -> SWClient? {
        return nil
    }
    
    public func currentIndexOfClient(client: SWClient?) -> Int? {
        if let c = client {
            return clientList.indexOf(c)
        } else {
            return nil
        }
    }
    
    public func currentIndexOfClient(withAccountName name: String) -> Int? {
        return nil
    }
    
    public var clientCount: Int {
        get {
            return clientList.count
        }
    }
    
    public let maxClientCount: Int  = 5
    
}
