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
    
    /// CoreData ManagedObjectContext. Assigne it when need to use ViviInterface core
    /// model.
    public lazy var managedObjectContext: NSManagedObjectContext? = VICoreDataController.shared.managedObjectContext
    
    /// Shared client manager.
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
    
    func showAlert(text: String) {
        let alert = NSAlert()
        alert.addButtonWithTitle("OK")
        alert.messageText = text
        alert.runModal()
    }
    
    /// Get unread message count. (read-only)
    public var unreadCount: Int {
        get {
            var count = 0
            for client in clientList {
                let clientMO = client.managedObject as! VIClientMO
                count += clientMO.unreadcount!.integerValue
            }
            return count
        }
    }
    
    /// Validate the SWAccount with account string ans password string.
    ///
    /// - Parameter account: Account string name, like 'node@exmaple.com'
    /// - Parameter passwd: Password string.
    /// - Throws: VIClientManagerError
    /// - Returns: Return new created account if validated, else return nil.
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
        
        let swaccount = SWAccount(accountName: account)
        if clientList.contains( { (c: SWClient) -> Bool in
            c.account.getAccountString() == swaccount.getAccountString()
        }) {
            NSLog("attempt to add conflicted client: \(account)")
            throw VIClientManagerError.AccountNameConfilct
        }
        
        if swaccount.valid {
            return swaccount
        } else {
            throw VIClientManagerError.AccountNameInvalid
        }
    }
    
    // MARK: - Access client
    
    /// Add Client with managedObject.
    /// - Throws: VIClientManagerError
    /// - Returns: Successfully added client or nil.
    func addClient(managedObject: VIClientMO) throws -> SWClient? {
        let accountname = managedObject.accountname
        let password = managedObject.password
        let swaccount = try validateAccount(accountname, passwd: password)
        let resIdx = swaccount.addResource(managedObject.resource)
        swaccount.setResourceIndex(resIdx)
        
        let newClient = SWClient(account: swaccount, password: password, eventLoop: eventLoop)
        newClient.managedObject = managedObject
        
        //        newClient.chatListController = VIChatListController(owner: newClient.account)
        
        clientList.append(newClient)
        delegate?.managerDidAddClient(newClient)
        NSLog("added client: \(newClient.account.getAccountString())")
        return newClient
    }
    
    /// Add Client without managedObject. **Do not** use managedObject later.
    /// - Throws: VIClientManagerError
    /// - Returns: Successfully added client or nil.
    internal func addClient(withAccountName account: String!, andPasswd passwd: String!) throws -> SWClient? {
        let swaccount = try validateAccount(account, passwd: passwd)
        
        let newClient = SWClient(account: swaccount, password: passwd, eventLoop: eventLoop)
        
//        newClient.chatListController = VIChatListController(owner: newClient.account)
        
        clientList.append(newClient)
        delegate?.managerDidAddClient(newClient)
        NSLog("added client: \(newClient.account.getAccountString())")
        return newClient
    }
    
    /// Remove specified client. If client has been added to client list, client
    /// will be removed from list after disconnected.
    /// 
    /// - Parameter client: Client to be removed from client list.
    public func removeClient(client: SWClient?) {
        if client == nil {
            return
        } else {
            if let i = clientList.indexOf(client!) {
                if client!.isActive() {
                    client!.disconnectWithHandler({ (errcode) -> Void in
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
    
    /// Remove specified client. For all clients in client list, client
    /// will be removed from list after disconnected.
    public func removeAllClient() {
        for c in clientList {
            removeClient(c)
        }
    }
    
    /// Force remove all clients, may cause to unexpected memory access error
    /// when client is not disconnected correctly.
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
    
    // MARK: - Client observer
    
    /// Add observers for unread count of all clients.
    public func addUnreadCountObservers(observer: NSObject) {
        for client in clientList {
            let clientMO = client.managedObject as! VIClientMO
            clientMO.addObserver(observer, forKeyPath: "unreadcount", options: NSKeyValueObservingOptions.New, context: nil)
        }
    }
    
    public func addUnreadCountObserver(observer: NSObject, forClient client: VIClientMO) {
        client.addObserver(observer, forKeyPath: "unreadcount", options: NSKeyValueObservingOptions.New, context: nil)
    }
}
