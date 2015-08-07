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
    private let eventLoop = SWEventLoop()
    public var delegate: VIClientManagerDelegate?
    
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
        "password": "password",
        "domain": "server name",
        "port": Int(5222),
        "enabled": NSOffState
    ];
    
    public func loadFromDefaults(defaults: NSUserDefaults) {
        let accountName = defaults.objectForKey("account") as! String
        let passwd = defaults.objectForKey("password") as! String
        do {
            try addClient(withAccountName: accountName, andPasswd: passwd)
        } catch VIClientManagerError.AccountNameConfilct {
            defaults.setObject(NSOffState, forKey: "enabled")
            let alert = NSAlert()
            alert.addButtonWithTitle("OK")
            alert.messageText = "There exists an conflicted accout, please change your account or use the existed account."
            alert.runModal()
        } catch VIClientManagerError.ClientAccountNameUnconvertible {
            defaults.setObject(NSOffState, forKey: "enabled")
            let alert = NSAlert()
            alert.addButtonWithTitle("OK")
            // FIXME: add format control
            alert.messageText = "Account name include illegal characters, please change your account."
            alert.runModal()
        } catch VIClientManagerError.ClientPasswordUnconvertible {
            defaults.setObject(NSOffState, forKey: "enabled")
            let alert = NSAlert()
            alert.addButtonWithTitle("OK")
            // FIXME: add format control
            alert.messageText = "Account password include illegal characters, please change your account."
            alert.runModal()
        } catch VIClientManagerError.TooManyClients {
            defaults.setObject(NSOffState, forKey: "enabled")
            let alert = NSAlert()
            alert.addButtonWithTitle("OK")
            alert.messageText = "There are too many clients."
            alert.runModal()
        } catch {
            defaults.setObject(NSOffState, forKey: "enabled")
            NSLog("Unknown error occured when add client")
        }
        defaults.setObject(NSOnState, forKey: "enabled")
    }
    
    private func addClient(withAccount account: SWAccount, andPasswd passwd: String!) throws -> SWClient? {
        let newClient = SWClient(account: account, password: passwd, eventLoop: eventLoop)
        guard !clientList.contains( { (c: SWClient) -> Bool in
            c.account.getAccountString() == account.getAccountString()
        }) else {
            throw VIClientManagerError.AccountNameConfilct
        }
        
        newClient.chatListController = VIChatListController(owner: newClient.account)
        
        clientList.append(newClient)
        delegate?.managerDidAddClient(newClient)
        return newClient
    }
    
    /**
        - Throws: VIClientManagerError: (AccountNameConfilct, ClientPasswordUnconvertible, ClientAccountNameUnconvertible, TooManyClients).
        - Returns: Successfully added client or nil.
    */
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
                        self.clientList.removeAtIndex(i)
                        self.delegate?.managerDidRemoveClient(client)
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
