//
//  CoreDataTests.swift
//  Vivi
//
//  Created by Junyuan Hong on 8/19/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import XCTest
import CoreData
@testable import ViviInterface

class VIAccountMOTests: XCTestCase {
    
    var moc: NSManagedObjectContext?

    override func setUp() {
        super.setUp()
        
        moc = setUpCoreData()
    }
    
    override func tearDown() {
        moc = nil
        
        super.tearDown()
    }
    
    func testInsertAccount() {
        var hasCatchError = false
        var testnode = "te#st.no@de"
        var testdomain = "test.domain"
        do {
            try VIAccountMO.addAccount(testnode, domain: testdomain, resource: "", managedObjectContext: moc!)
        } catch {
            hasCatchError = true
        }
        XCTAssertTrue(hasCatchError, "Not catch invalid error")
        XCTAssertNil(VIAccountMO.getAccount(testnode, domain: testdomain, managedObjectContext: moc!), "entity should have been removed.")
        
        hasCatchError = false
        testdomain = "test.dom#ain"
        do {
            try VIAccountMO.addAccount(testnode, domain: testdomain, resource: "", managedObjectContext: moc!)
        } catch {
            hasCatchError = true
        }
        XCTAssertTrue(hasCatchError, "Not catch invalid error")
        
        testnode = "test.node"
        testdomain = "test.domain"
        do {
            try VIAccountMO.addAccount(testnode, domain: testdomain, resource: "", managedObjectContext: moc!)
        } catch {
            XCTFail("catch unexpected error: \(error)")
        }
    }
    
    func testGetAccount() {
        let testnode = "te#st.no@de"
        let testdomain = "test.domain"
        XCTAssertNil(VIAccountMO.getAccount(testnode, domain: testdomain, managedObjectContext: moc!), "get not existed account.")
    }
    
    func testInsertDuplicatedAccount() {
        let testnode = "test.node"
        let testdomain = "test.domain"
        do {
            let a1 = try VIAccountMO.addAccount(testnode, domain: testdomain, resource: "", managedObjectContext: moc!)
            let a2 = try VIAccountMO.addAccount(testnode, domain: testdomain, resource: "", managedObjectContext: moc!)
            XCTAssertEqual(a1, a2, "two accounts should be the same one.")
            let aget = VIAccountMO.getAccount(testnode, domain: testdomain, managedObjectContext: moc!)
            XCTAssertEqual(a1, aget, "two accounts should be the same one.")
        } catch {
            fatalError("\(error)")
        }
    }
    
    func testSetGroup() {
        let testnode = "test.node"
        let testdomain = "test.domain"
        do {
            let account = try VIAccountMO.addAccount(testnode, domain: testdomain, resource: "", managedObjectContext: moc!)
            let group = NSEntityDescription.insertNewObjectForEntityForName("Group", inManagedObjectContext: moc!) as! VIGroupMO
            XCTAssertTrue(account.addGroup(group), "should be new group")
            XCTAssertNotNil(group.buddies, "group's buddies should not be nil")
            if let buddies = group.buddies {
                XCTAssertTrue(buddies.containsObject(account), "group should contain account")
            }
            XCTAssertNotNil(account.groups, "account's groups should not be nil")
            if let groups = account.groups {
                XCTAssertTrue(groups.containsObject(group), "account should belong to group")
            }
        } catch {
            fatalError("\(error)")
        }
    }

}
