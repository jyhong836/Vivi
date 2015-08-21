//
//  VIClientMOTests.swift
//  Vivi
//
//  Created by Junyuan Hong on 8/19/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import XCTest
import ViviSwiften
@testable import ViviInterface

class VIClientMOTests: XCTestCase {
    
    var moc: NSManagedObjectContext?
    var client: VIClientMO?
    
    override func setUp() {
        super.setUp()
        
        moc = setUpCoreData()
        client = NSEntityDescription.insertNewObjectForEntityForName("Client", inManagedObjectContext: moc!) as? VIClientMO
        client?.accountname = "test@client"
        client?.password = "123456"
    }
    
    override func tearDown() {
        moc = nil
        client = nil
        
        super.tearDown()
    }
    
    let notificationCenter = NSNotificationCenter.defaultCenter()
    let mainQueue = NSOperationQueue.mainQueue()
    
    func testAddChatWithBuddy() {
        var isReceivedNotification = false
        let observer = notificationCenter.addObserverForName(VIClientChatDidAddNotification, object: nil, queue: mainQueue, usingBlock: {
            (notification) -> Void in
            if let userInfo = notification.userInfo as? [String: AnyObject] {
                if let index = userInfo["index"] as? Int {
                    XCTAssertEqual(index, 0, "index should error")
                } else {
                    XCTFail("notification should has info for \"index\"")
                }
            }
            isReceivedNotification = true
        })
        
        let swaccount = SWAccount(accountName: "testaccount@xxx")
        let (chat, isNew) = client!.addChatWithBuddy(swaccount)
        XCTAssertTrue(isNew, "should be new chat")
        XCTAssertEqual(client?.chatCount, 1, "chat count error")
        XCTAssertNotNil(client!.chatAtIndex(0), "chat should have been added at index 0")
        XCTAssertTrue(client == chat.owner!, "client should be new chat's owner")
        XCTAssertEqual(chat.buddy!.node, swaccount.getNodeString(), "node error")
        XCTAssertEqual(chat.buddy!.domain, swaccount.getDomainString(), "domain error")
        
        XCTAssertEqual(client?.getChatWithBuddy(swaccount), chat, "get chat not correspond")
        
        XCTAssertTrue(isReceivedNotification, "should receive notification")
        notificationCenter.removeObserver(observer)
    }
    
    func testAddChats() {
        let swaccount1 = SWAccount(accountName: "testaccount@xxx.1")
        let (chat1, isNew1) = client!.addChatWithBuddy(swaccount1)
        XCTAssertTrue(isNew1, "chat should be new")
        let swaccount2 = SWAccount(accountName: "testaccount@xxx.2")
        let (chat2, isNew2) = client!.addChatWithBuddy(swaccount2)
        XCTAssertTrue(isNew2, "chat should be new")
        XCTAssertEqual(client!.chatCount, 2, "client should have two chat")
        XCTAssertEqual(client!.chats!.indexOfObject(chat2), 0, "added chat should at index 0")
        XCTAssertEqual(client!.chats!.indexOfObject(chat1), 1, "old chat should at index 1")
    }
    
//    func testRemoveChatAtIndex() {
//        let swaccount = SWAccount(accountName: "testaccount@xxx")
//        client!.addChatWithBuddy(swaccount)
//        
//        XCTAssertEqual(client!.chatCount, 1)
//        client!.removeChatAtIndex(0)
//        XCTAssertEqual(client!.chatCount, 0)
//    }

}
