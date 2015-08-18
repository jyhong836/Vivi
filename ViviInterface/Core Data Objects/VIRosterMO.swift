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
        let items = roster.getItems()
        for groupname in roster.getGroups() {
            addGroup(groupname)
        }
        for item in items {
            let newAccount = VIAccountMO.addAccount(item.account, managedObjectContext: self.managedObjectContext!)
            for groupname in item.groups {
                let (groupMO, _) = addGroup(groupname as! String)
                newAccount.addGroup(groupMO)
            }
        }
        NSLog("roster did initialize")
    }
    
    public func roster(roster: SWXMPPRoster!, didAddAccount account: SWAccount!) {
        NSLog("roster did add client")
    }
    
    // MARK: Roster access methods
    
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
