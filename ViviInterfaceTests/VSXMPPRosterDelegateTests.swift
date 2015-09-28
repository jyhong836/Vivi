//
//  VSXMPPRosterDelegateTests.swift
//  Vivi
//
//  Created by Junyuan Hong on 8/21/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import XCTest
import ViviSwiften
@testable import ViviInterface

class VSXMPPRosterDelegateTests: XCTestCase {
    
    var moc: NSManagedObjectContext?
    var instance: VSXMPPRosterDelegate?
    
    let testGroupName: [String] = ["test group 1", "test group 2"]
    let node = "test"
    let domain = "xxx"
    
    override func setUp() {
        super.setUp()
        
        moc = setUpCoreData()
        instance = NSEntityDescription.insertNewObjectForEntityForName("Roster", inManagedObjectContext: moc!) as? VIRosterMO
        
        if let roster = instance as? VIRosterMO {
            roster.addGroup(testGroupName[0])
        } else {
            XCTFail("Unimplemented test for this type of VSXMPPRosterDelegate")
        }
    }
    
    override func tearDown() {
        moc = nil
        
        super.tearDown()
    }
    
    func testRosterDidInitialize() {
//        if let roster = instance as? VIRosterMO {
//            let groupname = "test"
//            roster.addGroup(groupname)
//            roster.rosterDidInitialize(nil)
//        } else {
            XCTFail("Unimplemented test for this type of VSXMPPRosterDelegate")
//        }
    }

    func testRosterDidAddAccount() {
        if !instance!.respondsToSelector(Selector("roster:didAddAccount:")) {
            XCTFail("Instance has not implement \"roster:didAddAccount:\"")
        }
        instance!.roster!(nil, didAddAccount: SWAccount(accountName: "\(node)@\(domain)"))
        let account = VIAccountMO.getAccount(node, domain: domain, managedObjectContext: moc!)
        XCTAssertNotNil(account, "should have added account")
        if account != nil {
            XCTAssertEqual(account!.node, node, "node doesn't correspond")
            XCTAssertEqual(account!.domain, domain, "domain  doesn't correspond")
        }
    }
    
    func testRosterDidRemoveAccount() {
        if !instance!.respondsToSelector(Selector("roster:didRemoveAccount:")) {
            XCTFail("Instance has not implement \"roster:didRemoveAccount:\"")
        }
        if let roster = instance as? VIRosterMO {
            do {
                try VIAccountMO.addAccount(node+"1", domain: domain, resource: "", managedObjectContext: moc!)
                XCTAssertNotNil(VIAccountMO.getAccount(node+"1", domain: domain, managedObjectContext: moc!), "account should have been added")
                let account = try VIAccountMO.addAccount(node, domain: domain, resource: "", managedObjectContext: moc!)
                XCTAssertNotNil(VIAccountMO.getAccount(node, domain: domain, managedObjectContext: moc!), "account should have been added")
                roster.roster(nil, didRemoveAccount: account.swaccount)
                XCTAssertNil(VIAccountMO.getAccount(node, domain: domain, managedObjectContext: moc!), "account should have been removed")
                XCTAssertNotNil(VIAccountMO.getAccount(node+"1", domain: domain, managedObjectContext: moc!), "account should have been added")
            } catch {
                XCTFail("Unexpected error")
            }
        } else {
            XCTFail("Unimplemented test for this type of VSXMPPRosterDelegate")
        }
    }
    
    func testDidUpdateItem() {
        if let roster = instance as? VIRosterMO {
            roster.roster(nil, didUpdateItem: SWRosterItem(name: "name", accountName: "\(node)@\(domain)", group: "Buddies"))
            let group = roster.getGroup("Buddies")
            XCTAssertNotNil(group, "should have added group")
            let account = VIAccountMO.getAccount(node, domain: domain, managedObjectContext: moc!)
            XCTAssertNotNil(account?.groups?.containsObject(group!), "account should have set group")
        } else {
            XCTFail("Unimplemented test for this type of VSXMPPRosterDelegate")
        }
    }
    
    func testRosterDidClear() {
        if let roster = instance as? VIRosterMO {
            for e in roster.groups! {
                let group = e as! VIGroupMO
                XCTAssertFalse(group.isShouldBeDeleted, "new group should not be set isShouldBeDeleted flag")
                roster.rosterDidClear(nil)
                XCTAssertFalse(group.isShouldBeDeleted, "rosterDidClear should not change isShouldBeDeleted flag")
            }
        } else {
            XCTFail("Unimplemented test for this type of VSXMPPRosterDelegate")
        }
    }
}
