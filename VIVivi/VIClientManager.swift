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
    case ClientPasswordUnconvertible
    case ClientAccountNameUnconvertible
    case TooManyClients
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
    
    public func startClientLoop() {
        eventLoop.start()
    }
    
    deinit {
        // TODO: Test if the evenLoop and VIClientManager will be deinit
        eventLoop.stop()
    }
    
    private func addClient(withAccount account: SWAccount, andPasswd passwd: String!) throws -> SWClient? {
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
        guard account.canBeConvertedToEncoding(NSString.defaultCStringEncoding()) else {
            throw VIClientManagerError.ClientAccountNameUnconvertible
        }
        guard passwd.canBeConvertedToEncoding(NSString.defaultCStringEncoding()) else {
            throw VIClientManagerError.ClientPasswordUnconvertible
        }
        guard clientCount < maxClientCount else {
            throw VIClientManagerError.TooManyClients
        }
        return try self.addClient(withAccount: SWAccount(accountName: account), andPasswd: passwd)
    }
    
    public func removeClient(client: SWClient?) {
        if client == nil {
            return
        } else {
            if let i = clientList.indexOf(client!) {
                if client!.isActive() {
                    client!.disconnectWithHandler({ () -> Void in
                        clientList.removeAtIndex(i)
                    })
                }
            }
        }
    }
    
    public func removeAllClient() {
        for c in clientList {
            removeClient(c)
        }
    }
    
    /// Force remove all clients, may cause to unexpected memory access error.
    internal func forceRemoveAllClient() {
        clientList.removeAll()
    }
    
    public func getClient(withAccountName name: String) -> SWClient? {
        if !name.canBeConvertedToEncoding(NSString.defaultCStringEncoding()) {
            return nil
        }
        let account = SWAccount(accountName: name)
        for c in clientList {
            if c.account.getAccountString() == account.getAccountString() {
                return c
            }
        }
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
        return currentIndexOfClient(getClient(withAccountName: name))
    }
    
    public var clientCount: Int {
        get {
            return clientList.count
        }
    }
    
    // FIXME: Multi-client is unsafe when deleted
    public let maxClientCount: Int  = 5
}
