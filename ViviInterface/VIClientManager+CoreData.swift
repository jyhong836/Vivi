//
//  VIClientManager+CoreData.swift
//  Vivi
//
//  Created by Junyuan Hong on 8/11/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Foundation
import CoreData
import ViviSwiften

/// Require the managedObjectContext to be set.
extension VIClientManager {
    
    /// Call this when application starts to load clients from CoreData.
    /// This will only load enabled client enities to client manager.
    public func loadFromEnities() {
        let moc = self.managedObjectContext!
        let clientFetch = NSFetchRequest(entityName: "Client")
        let clientEnabled = true
        clientFetch.predicate = NSPredicate(format: "enabled == \(NSNumber(bool: clientEnabled))")
        
        do {
            let fetchedClients = try moc.executeFetchRequest(clientFetch) as! [VIClientMO]
            NSLog("enity num: \(fetchedClients.count)")
            for client in fetchedClients {
                loadFromEnity(client)
            }
        } catch {
            fatalError("Failed to fetch clients: \(error)")
        }
    }
    
    /// Call this when new enity should be added to client manager. When new VIClientMO is 
    /// created, use `canAddClientEnity` to make sure it's validated.
    public func loadFromEnity(clientMO: VIClientMO) {
        do {
            let client = try addClient(clientMO)
            if let cl = client {
                cl.manualHostname = clientMO.hostname
                cl.manualPort = (clientMO.port?.intValue)!
                cl.priority = (clientMO.priority?.intValue)!
                
                cl.roster.delegate = clientMO.roster!
                cl.avatarDelegate = clientMO
            }
            clientMO.enabled = NSNumber(bool: true)
        } catch VIClientManagerError.AccountNameConfilct {
            clientMO.enabled = NSNumber(bool: false)
            showAlert("There exists an conflicted accout, please change your account or use the existed account.")
        } catch VIClientManagerError.ClientAccountNameUnconvertible {
            clientMO.enabled = NSNumber(bool: false)
            showAlert("Account name include illegal characters, please change your account.")
        } catch VIClientManagerError.ClientPasswordUnconvertible {
            // FIXME: add format control
            showAlert("Account password include illegal characters, please change your account.")
        } catch VIClientManagerError.TooManyClients {
            clientMO.enabled = NSNumber(bool: false)
            showAlert("There are too many clients.")
        } catch {
            clientMO.enabled = NSNumber(bool: false)
            NSLog("Unknown error occured when add client: \(error)")
        }
    }
    
    /// Try to add new client enity. If can add client with account and passwd, return new SWAccount. If account has
    /// existed, return nil.
    /// - Throws: VIClientManagerError
    public func canAddClientEnity(withAccountName account: String!, andPasswd passwd: String!) throws -> SWAccount? {
        let moc = self.managedObjectContext!
        let clientFetch = NSFetchRequest(entityName: "Client")
        
        let swaccount: SWAccount? = try validateAccount(account, passwd: passwd)
        
        do {
            let fetchedClients = try moc.executeFetchRequest(clientFetch) as! [VIClientMO]
            if !fetchedClients.contains({ (client: VIClientMO) -> Bool in
                return client.accountname == account
            }) {
                return swaccount
            } else {
                throw VIClientManagerError.AccountNameConfilct
            }
        } catch VIClientManagerError.AccountNameConfilct {
            throw VIClientManagerError.AccountNameConfilct
        } catch {
            fatalError("Failed to fetch clients: \(error)")
        }
        return nil
    }
}
