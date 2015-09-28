//
//  VIAccountMO.swift
//  Vivi
//
//  Created by Junyuan Hong on 8/11/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Foundation
import CoreData
import ViviSwiften

public class VIAccountMO: NSManagedObject {
    
    public override func awakeFromInsert() {
        groups = NSSet()
        resources = NSSet()
        resource = ""
    }
    
    public var string: String {
        get {
            if resource!.isEmpty {
                return "\(node!)@\(domain!)"
            } else {
                return "\(node!)@\(domain!)/\(resource!)"
            }
        }
    }
    
    public var bareString: String {
        get {
            return "\(node!)@\(domain!)"
        }
    }
    
    // MARK: - Account accessors(static)
    
    public var swaccount: SWAccount? {
        get {
            return SWAccount(accountName: string)
        }
//        set {
//            self.node = newValue?.node
//            self.domain = newValue?.domain
////            for resource in newValue
//            NSEntityDescription.insertNewObjectForEntityForName("Resource", inManagedObjectContext: self.managedObjectContext!)
//        }
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
    ///
    /// - Parameter node: Account node string.
    /// - Parameter domain: Account domain string.
    /// - Parameter resource: Account resource string.
    /// - Parameter managedObjectContext: NSManagedObjectContext
    /// for core data.
    /// - Throws: addAccount will call account.validateForInsert(),
    /// and throw relevant NSError after delete invalidate account.
    public static func addAccount(node: String, domain: String, resource: String, managedObjectContext moc: NSManagedObjectContext) throws -> VIAccountMO {
        // search for existed account
        if let existedAccount = getAccount(node, domain: domain, managedObjectContext: moc) {
            existedAccount.addResource(resource)
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
            account.addResource(resource)
            return account
        }
    }
    
    /// Add new account or get existed account. Entity will be
    /// validated immediately, throw relevant error when failed
    /// and delete the entity from managedObjectContext. If account
    /// has existed, only add resource to the account, but do not
    /// change the account default resource. Asign value to 
    /// resource attribute to change default resource.
    ///
    /// - Parameter swaccount: SWAccount stored relevant messages.
    /// - Parameter managedObjectContext: NSManagedObjectContext
    /// for core data.
    /// - Throws: addAccount will call account.validateForInsert(),
    /// and throw relevant NSError after delete invalidate account.
    public static func addAccount(swaccount: SWAccount, managedObjectContext moc: NSManagedObjectContext) throws -> VIAccountMO {
        return try addAccount(swaccount.node, domain: swaccount.domain, resource: swaccount.resource, managedObjectContext: moc)
    }
    
    /// Try to remove account. If account does not exist in core
    /// data, just return.
    public static func removeAccount(node: String, domain: String, managedObjectContext moc: NSManagedObjectContext) {
        if let account = getAccount(node, domain: domain, managedObjectContext: moc) {
            moc.deleteObject(account)
        }
    }
    
    /// Try to remove account. If account does not exist in core
    /// data, return without do anything.
    public static func removeAccount(swaccount: SWAccount, managedObjectContext moc: NSManagedObjectContext) {
        removeAccount(swaccount.node, domain: swaccount.domain, managedObjectContext: moc)
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
    
    /// Return true, if add new group set to account.
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
    
    // MARK: Resource accessors
    
    /// Return true if exist resource.
    func existResource(name: String) -> Bool {
        for element in self.resources! {
            let resource = element as! VIResourceMO
            if (resource.name == name) {
                return true
            }
        }
        return false
    }
    
    /// Return true, if add new resource to account. Use static method 
    /// `addAccount` to add resource to existed account instead of this
    /// method. Set default resource by asigning value to resource later,
    /// if you'd like to change the resource.
    func addResource(name: String) -> Bool {
        if existResource(name) {
            return false
        } else {
            let resource = NSEntityDescription.insertNewObjectForEntityForName("Resource", inManagedObjectContext: self.managedObjectContext!) as! VIResourceMO
            resource.name = name
            resource.account = self
            return true
        }
    }
    
}
