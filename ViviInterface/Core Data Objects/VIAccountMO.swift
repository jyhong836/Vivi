//
//  Account.swift
//  Vivi
//
//  Created by Junyuan Hong on 8/11/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Foundation
import CoreData
import ViviSwiften


//@objc(Account)
public class VIAccountMO: NSManagedObject {
    
    public override func awakeFromInsert() {
        groups = NSSet()
        resources = NSSet()
    }
    
    public var accountString: String {
        get {
            return "\(node!)@\(domain!)"
        }
    }
    
    // MARK: - Account accessors(static)
    
    public var swaccount: SWAccount? {
        get {
            return SWAccount(accountName: accountString)
        }
        set {
            self.node = newValue?.getNodeString()
            self.domain = newValue?.getDomainString()
        }
    }
    
    /// Get existed group.
    public static func getAccount(node: String, domain: String, managedObjectContext moc: NSManagedObjectContext) -> VIAccountMO? {
        let fetchRequest = NSFetchRequest(entityName: "Account")
        fetchRequest.predicate = NSPredicate(format: "(node == %@) AND (domain == %@)", node, domain)
        do {
            let fetchedAccounts = try moc.executeFetchRequest(fetchRequest) as! [VIAccountMO]
            guard fetchedAccounts.count <= 1 else {
                fatalError("More than one account with the same node and domain.")
            }
            if fetchedAccounts.count == 1 {
                return fetchedAccounts[0]
            } else {
                return nil
            }
        } catch {
            fatalError("Fail to fetch account, error: \(error)")
        }
    }
    
    /// Add new account or get existed account. Entity will be
    /// validated immediately, throw relevant error when failed 
    /// and delete the entity from managedObjectContext.
    /// - Parameter node: Account node string.
    /// - Parameter domain: Account domain string.
    /// - Parameter managedObjectContext: NSManagedObjectContext
    /// for core data.
    /// - Throws: addAccount will call account.validateForInsert(),
    /// and throw relevant NSError after delete invalidate account.
    public static func addAccount(node: String, domain: String, managedObjectContext moc: NSManagedObjectContext) throws -> VIAccountMO {
        if let existedAccount = getAccount(node, domain: domain, managedObjectContext: moc) {
            return existedAccount
        } else {
            let account = NSEntityDescription.insertNewObjectForEntityForName("Account", inManagedObjectContext: moc) as! VIAccountMO
            account.node = node
            account.domain = domain
            do {
                try account.validateForInsert()
            } catch {
                moc.deleteObject(account)
                throw error
            }
            return account
        }
    }
    
    /// Add new account or get existed account. Entity will be
    /// validated immediately, throw relevant error when failed
    /// and delete the entity from managedObjectContext.
    /// - Parameter swaccount: SWAccount stored relevant messages.
    /// - Parameter managedObjectContext: NSManagedObjectContext
    /// for core data.
    /// - Throws: addAccount will call account.validateForInsert(),
    /// and throw relevant NSError after delete invalidate account.
    public static func addAccount(swaccount: SWAccount, managedObjectContext moc: NSManagedObjectContext) throws -> VIAccountMO {
        return try addAccount(swaccount.getNodeString(), domain: swaccount.getDomainString(), managedObjectContext: moc)
    }
    
    public static func removeAccount(node: String, domain: String, managedObjectContext moc: NSManagedObjectContext) {
        if let account = getAccount(node, domain: domain, managedObjectContext: moc) {
            moc.deleteObject(account)
        }
    }
    
    public static func removeAccount(swaccount: SWAccount, managedObjectContext moc: NSManagedObjectContext) {
        removeAccount(swaccount.getNodeString(), domain: swaccount.getDomainString(), managedObjectContext: moc)
    }
    
    // MARK: - Group accessors
    
    /// Return true if exist group.
    func existGroup(newGroup: VIGroupMO) -> Bool {
        for element in self.groups! {
            let group = element as! VIGroupMO
            if (group.name == newGroup.name) {
                return true
            }
        }
        return false
    }
    
    /// Return true, if add new group to account.
    func addGroup(newGroup: VIGroupMO) -> Bool {
        if existGroup(newGroup) {
            return false
        } else {
            let groups = self.mutableSetValueForKey("groups")
            groups.addObject(newGroup)
            return true
        }
    }
    
    // MARK: Account presence
    
    public var presence: SWPresenceType = SWPresenceType.Unavailable
    public var presenceshow: SWPresenceShowType = SWPresenceShowType.None
    public var status: String = ""
    
}
