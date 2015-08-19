//
//  VIRosterMOTests.swift
//  Vivi
//
//  Created by Junyuan Hong on 8/19/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import XCTest
@testable import ViviInterface

class VIRosterMOTests: XCTestCase {
    
    var moc: NSManagedObjectContext?
    
    override func setUp() {
        super.setUp()
        
        moc = setUpCoreData()
    }
    
    override func tearDown() {
        moc = nil
        
        super.tearDown()
    }
    
    func testSetGroup() {
        let roster = NSEntityDescription.insertNewObjectForEntityForName("Roster", inManagedObjectContext: moc!) as! VIRosterMO
        let groupname = "testGroup"
        let (group, isNew) = roster.addGroup(groupname)
        XCTAssertTrue(isNew, "should be new group")
        XCTAssertNotNil(group.roster, "group's buddies should not be nil")
        if let groster = group.roster {
            XCTAssertEqual(groster, roster, "group's roster should correspond to setting")
        }
        XCTAssertNotNil(roster.groups, "account's groups should not be nil")
        if let groups = roster.groups {
            XCTAssertTrue(groups.containsObject(group), "account should belong to group")
        }
    }

}
