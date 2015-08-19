//
//  VIChatTests.swift
//  Vivi
//
//  Created by Junyuan Hong on 8/19/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import XCTest
@testable import ViviInterface

class VIChatMOTests: XCTestCase {
    
    var moc: NSManagedObjectContext?

    override func setUp() {
        super.setUp()
        
        moc = setUpCoreData()
    }
    
    override func tearDown() {
        moc = nil
        
        super.tearDown()
    }
    
    func testCreateChat() {
        let beforeCreateTime = NSDate()
        let chat = NSEntityDescription.insertNewObjectForEntityForName("Chat", inManagedObjectContext: moc!) as! VIChatMO
        XCTAssertTrue(chat.createdtime!.compare(NSDate()) == .OrderedAscending)
        XCTAssertTrue(chat.createdtime!.compare(beforeCreateTime) == .OrderedDescending)
        XCTAssertTrue(chat.createdtime!.compare(chat.updatedtime!) == .OrderedSame, "created time and updated time not equal")
        XCTAssertNotNil(chat.messages, "messages should not be nil after insert chat")
    }
    
    func testAddMessages() {
        let chat = NSEntityDescription.insertNewObjectForEntityForName("Chat", inManagedObjectContext: moc!) as! VIChatMO
        let messageContent0 = "test1"
        chat.addMessage(messageContent0, timestamp: NSDate(), direction: .To)
        let messageTime = NSDate()
        let messageContent = "test message"
        let message = chat.addMessage(messageContent, timestamp: messageTime, direction: .To)
        XCTAssertEqual(chat.messageCount, 2, "there should have one messsage")
        XCTAssertEqual(chat.messageAtIndex(1), message, "index 0 should be inserted message")
        XCTAssertEqual(chat.indexOfMessage(message), 1, "message should at index 0")
        XCTAssertEqual(chat.lastMessage, messageContent, "message content not correspond to setting")
        XCTAssertEqual(chat.messageAtIndex(0)!.content!, messageContent0, "message content not correspond to setting")
    }

}
