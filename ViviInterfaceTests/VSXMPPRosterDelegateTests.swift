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
        if let roster = instance as? VIRosterMO {
            // FIXME: unable to test the cocurrent function.
        } else {
            XCTFail("Unimplemented test for this type of VSXMPPRosterDelegate")
        }
    }

    func testRosterDidAddAccount() {
        let node = "test"
        let domain = "xxx"
        instance!.roster!(nil, didAddAccount: SWAccount(accountName: "\(node)@\(domain)"))
        // FIXME: unable to test the cocurrent function.
//        let account = VIAccountMO.getAccount(node, domain: domain, managedObjectContext: moc!)
//        XCTAssertNotNil(account, "should have added account")
//        if account != nil {
//            XCTAssertEqual(account!.node, node, "node doesn't correspond")
//            XCTAssertEqual(account!.domain, domain, "domain  doesn't correspond")
//        }
    }
    
    func testRosterDidRemoveAccount() {
        if let roster = instance as? VIRosterMO {
            // FIXME: unable to test the cocurrent function.
        } else {
            XCTFail("Unimplemented test for this type of VSXMPPRosterDelegate")
        }
    }
    
    func testDidUpdateItem() {
        if let roster = instance as? VIRosterMO {
            // FIXME: unable to test the cocurrent function.
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
