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
    case AccountNameInvalid
    case AccountNameConfilct
    case ClientPasswordUnconvertible
    case ClientAccountNameUnconvertible
    case TooManyClients
}

public protocol VIClientManagerDelegate {
    func managerDidAddClient(client: SWClient?)
    func managerDidRemoveClient(client: SWClient?)
}

/**
 * Manager for clients. Client should only be created through VIClientManager.
 */
public class VIClientManager: VIClientManagerProtocol {
    private var clientList: [SWClient]! = []
    // FIXME: eventloop should be managed by VIClientManager?
    public let eventLoop = SWEventLoop()
    public var delegate: VIClientManagerDelegate?
    
    public weak var managedObjectContext: NSManagedObjectContext?
    
    public static let sharedClientManager: VIClientManager = {
        let instance = VIClientManager()
        // init code here
        return instance
        }()
    
    /// Must be called for starting Swiften EventLoop.
    public func startClientLoop() {
        eventLoop.start()
    }
    
    deinit {
        // TODO: Test if the evenLoop and VIClientManager will be deinit
        eventLoop.stop()
    }
    
    public let clientManagerDefaults: [String: AnyObject] = [
        "account": "",
        "password": "",
        "hostname": "",
        "port": Int(5222),
        "enabled": NSOffState
    ];
    
    func showAlert(text: String) {
        let alert = NSAlert()
        alert.addButtonWithTitle("OK")
        alert.messageText = text
        alert.runModal()
    }
    
    func validateAccount(account: String!, passwd: String!) throws -> SWAccount {
        if !account.canBeConvertedToEncoding(NSString.defaultCStringEncoding()) {
            throw VIClientManagerError.ClientAccountNameUnconvertible
        }
        if !passwd.canBeConvertedToEncoding(NSString.defaultCStringEncoding()) {
            throw VIClientManagerError.ClientPasswordUnconvertible
        }
        if clientCount >= maxClientCount {
            throw VIClientManagerError.TooManyClients
        }
        
        if clientList.contains( { (c: SWClient) -> Bool in
            c.account.getAccountString() == account
        }) {
            NSLog("attempt to add conflicted client: \(account)")
            throw VIClientManagerError.AccountNameConfilct
        }
        
        let swaccount = SWAccount(accountName: account)
        if swaccount.valid {
            return swaccount
        } else {
            throw VIClientManagerError.AccountNameInvalid
        }
    }
    
    /**
        - Throws: VIClientManagerError: (AccountNameConfilct, ClientPasswordUnconvertible, ClientAccountNameUnconvertible, TooManyClients).
        - Returns: Successfully added client or nil.
    */
    public func addClient(withAccountName account: String!, andPasswd passwd: String!) throws -> SWClient? {
        let swaccount = try validateAccount(account, passwd: passwd)
        
        let newClient = SWClient(account: swaccount, password: passwd, eventLoop: eventLoop)
        
        newClient.chatListController = VIChatListController(owner: newClient.account)
        
        clientList.append(newClient)
        delegate?.managerDidAddClient(newClient)
        NSLog("added client: \(newClient.account.getAccountString())")
        return newClient
    }
    
    public func removeClient(client: SWClient?) {
        if client == nil {
            return
        } else {
            if let i = clientList.indexOf(client!) {
                if client!.isActive() {
                    client!.disconnectWithHandler({ () -> Void in
                        self.clientList.removeAtIndex(i)
                        self.delegate?.managerDidRemoveClient(client)
                    })
                } else {
                    clientList.removeAtIndex(i)
                    delegate?.managerDidRemoveClient(client)
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
