//
//  Roster.swift
//  Vivi
//
//  Created by Junyuan Hong on 8/11/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Foundation
import CoreData
import ViviSwiften

//@objc(Roster)
public class VIRosterMO: NSManagedObject, VSXMPPRosterDelegate {
    
    public override func awakeFromInsert() {
        groups = NSSet()
    }
    
    // MARK: Conform VSXMPPRosterDelegate
    
    public func rosterDidInitialize(roster: SWXMPPRoster!) {
        NSLog("roster did initialize")
        let items = roster.getItems() as NSArray as! [SWRosterItem!]
        for groupname in roster.getGroups() {
            self.addGroup(groupname)
        }
        do {
            for item in items {
                let newAccount = try VIAccountMO.addAccount(item.account, managedObjectContext: self.managedObjectContext!)
                for groupname in (item.groups as NSArray as! [String!]) {
                    let (groupMO, _) = self.addGroup(groupname)
                    newAccount.addGroup(groupMO)
                }
            }
        } catch {
            fatalError("Fail to add account: \(error)")
        }
        self.removeNotUpdatedGroup()
    }
    
    public func roster(roster: SWXMPPRoster!, didAddAccount account: SWAccount!) {
        NSLog("roster did add account: \(account.getAccountString())")
        do {
            try VIAccountMO.addAccount(account, managedObjectContext: self.managedObjectContext!)
        } catch {
            fatalError("Fail to add account: \(error)")
        }
    }
    
    public func roster(roster: SWXMPPRoster!, didRemoveAccount account: SWAccount!) {
        NSLog("roster did remove account: \(account.getAccountString())")
        VIAccountMO.removeAccount(account, managedObjectContext: self.managedObjectContext!)
    }
    
    public func roster(roster: SWXMPPRoster!, didUpdateItem item: SWRosterItem!) {
        NSLog("roster did update item name: \(item.name)")
        do {
            let newAccount = try VIAccountMO.addAccount(item.account, managedObjectContext: self.managedObjectContext!)
            for groupname in (item.groups as NSArray as! [String!]) {
                let (groupMO, _) = addGroup(groupname)
                newAccount.addGroup(groupMO)
            }
        } catch {
            fatalError("Fail to add account: \(error)")
        }
    }
    
    public func rosterDidClear(roster: SWXMPPRoster!) {
        NSLog("roster did clear")
    }
    
    // MARK: Roster access methods
    
    func removeNotUpdatedGroup() {
        let groups = self.mutableSetValueForKey("groups") as NSMutableSet
        for e in groups {
            let group = e as! VIGroupMO
            if group.isShouldBeDeleted {
                managedObjectContext!.deleteObject(group)
            }
        }
    }
    
    /// Get existed group.
    func getGroup(name: String) -> VIGroupMO? {
        for element in self.groups! {
            let group = element as! VIGroupMO
            if (group.name == name) {
                return group
            }
        }
        return nil
    }
    
    /// Add new group or get existed group.
    func addGroup(newGroupName: String) -> (VIGroupMO, isNew: Bool) {
        if let group = getGroup(newGroupName) {
            // FIXME: This would be not efficient if addGroup is called often.
            group.isShouldBeDeleted = false
            return (group, false)
        } else {
            let moc = self.managedObjectContext
            let group = NSEntityDescription.insertNewObjectForEntityForName("Group", inManagedObjectContext: moc!) as! VIGroupMO
            group.name = newGroupName
            group.roster = self
            return (group, true)
        }
    }
    
}
