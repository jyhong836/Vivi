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
        //TODO: add items to group
        NSLog("roster did initialize")
    }
    
    public func roster(roster: SWXMPPRoster!, didAddAccount account: SWAccount!) {
        NSLog("roster did add client")
    }
    
    // MARK: Roster access methods
    
    func getGroup(name: String) -> VIGroupMO? {
        for element in self.groups! {
            let group = element as! VIGroupMO
            if (group.name == name) {
                return group
            }
        }
        return nil
    }
    
    func addGroup(newGroupName: String) -> (VIGroupMO, isNew: Bool) {
        if let group = getGroup(newGroupName) {
            return (group, true)
        } else {
            let moc = self.managedObjectContext
            let group = NSEntityDescription.insertNewObjectForEntityForName("Group", inManagedObjectContext: moc!) as! VIGroupMO
            group.name = newGroupName
            group.roster = self
            return (group, false)
        }
    }
    
}
