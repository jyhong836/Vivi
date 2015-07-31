//
//  VIChatListControllerTests.swift
//  Vivi
//
//  Created by Junyuan Hong on 7/31/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import XCTest
import ViviSwiften
@testable import ViviInterface

class VIChatListControllerTests: XCTestCase {
    
    var chatListController: VIChatListController!
    var client: SWClient!
    var fakeAccount = ["fake1", "fake2", "fake3"]

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        client = SWClientFactory.createClient(0)
        chatListController = VIChatListController(owner: client.account)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testUpdateChatList() {
        var chats: [VIChat] = []
        
        chats.append(chatListController.updateChatList(withBuddy: SWAccount(accountName: fakeAccount[0]), message: "test", timestamp: NSDate()))
        chatListController.updateChatList(withBuddy: SWAccount(accountName: fakeAccount[0]), message: "test", timestamp: NSDate())
        XCTAssertEqual(chatListController.chatCount, 1, "Chat list can not found same chat")
        chats.append(chatListController.updateChatList(withBuddy: SWAccount(accountName: fakeAccount[1]), message: "test", timestamp: NSDate()))
        XCTAssertEqual(chatListController.chatCount, 2, "Chat list can not add different chat")
        var i: Int = Int(chatListController.chatList.indexOf { (c) -> Bool in
            c.buddy.getFullAccountString() == chats[1].buddy.getFullAccountString()
        }! )
        XCTAssertEqual(i, 0, "Fail to move new chat to index 0")
        chats.append(chatListController.updateChatList(withBuddy: SWAccount(accountName: fakeAccount[2]), message: "test", timestamp: NSDate()))
        chatListController.updateChatList(withBuddy: SWAccount(accountName: fakeAccount[0]), message: "new test", timestamp: NSDate())
        XCTAssertEqual(chatListController.chatCount, 3, "Chat count wrong")
        i = Int(chatListController.chatList.indexOf { (c) -> Bool in
            c.buddy.getFullAccountString() == chats[0].buddy.getFullAccountString()
            }! )
        XCTAssertEqual(i, 0, "Fail to move updated chat to index 0")
        XCTAssertEqual(chats[0].lastMessage, "new test", "Fail to update new message")
        
        XCTAssertEqual(chatListController.chatAtIndex(0)!, chats[0], "Incorrect index")
    }
    
    func testAddChat() {
        chatListController.addChatWithBuddy(SWAccount(accountName: fakeAccount[0]))
        chatListController.addChatWithBuddy(SWAccount(accountName: fakeAccount[1]))
        XCTAssertEqual(chatListController.chatCount, 2, "Fail to add chat with buddy")
        chatListController.addChatWithBuddy(SWAccount(accountName: fakeAccount[0]))
        XCTAssertEqual(chatListController.chatCount, 2, "ChatListController can not found same chat")
    }

}
