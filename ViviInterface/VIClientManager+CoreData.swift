//
//  VIClientManager+CoreData.swift
//  Vivi
//
//  Created by Junyuan Hong on 8/11/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Foundation
import CoreData

/// Require the managedObjectContext to be set.
extension VIClientManager {
    
    public func loadFromEnities() {
        let moc = self.managedObjectContext!
        let clientFetch = NSFetchRequest(entityName: "Client")
        let clientEnabled = true
        clientFetch.predicate = NSPredicate(format: "enabled == \(NSNumber(bool: clientEnabled))")
        
        do {
            let fetchedClients = try moc.executeFetchRequest(clientFetch) as! [VIClientMO]
            for client in fetchedClients {
                loadFromEnity(client)
            }
        } catch {
            fatalError("Failed to fetch clients: \(error)")
        }
    }
    
    public func loadFromEnity(clientEnity: VIClientMO) {
        let accountName = clientEnity.accountname!
        let passwd = clientEnity.password!
        do {
            let client = try addClient(withAccountName: accountName, andPasswd: passwd)
            if let cl = client {
                cl.manualHostname = clientEnity.hostname
                cl.manualPort = (clientEnity.port?.intValue)!
            }
            clientEnity.enabled = NSNumber(bool: true)
        } catch VIClientManagerError.AccountNameConfilct {
            clientEnity.enabled = NSNumber(bool: false)
            showAlert("There exists an conflicted accout, please change your account or use the existed account.")
        } catch VIClientManagerError.ClientAccountNameUnconvertible {
            clientEnity.enabled = NSNumber(bool: false)
            showAlert("Account name include illegal characters, please change your account.")
        } catch VIClientManagerError.ClientPasswordUnconvertible {
            // FIXME: add format control
            showAlert("Account password include illegal characters, please change your account.")
        } catch VIClientManagerError.TooManyClients {
            clientEnity.enabled = NSNumber(bool: false)
            showAlert("There are too many clients.")
        } catch {
            clientEnity.enabled = NSNumber(bool: false)
            NSLog("Unknown error occured when add client: \(error)")
        }
    }
}
