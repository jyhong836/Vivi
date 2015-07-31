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
    
    let chatListController = VIChatListController()

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testUpdateChatList() {
        var fakeAccount = ["fake1", "fake2", "fake3"]
        var chats: [VIChat] = []
        let client = SWClientFactory.createClient(0)
        chats.append(chatListController.updateChatList(client, buddy: SWAccount(accountName: fakeAccount[0]), message: "test message", timestamp: NSDate()))
        
    }

}
