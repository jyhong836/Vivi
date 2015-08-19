//
//  VSClientControllerProtocolTests.swift
//  Vivi
//
//  Created by Junyuan Hong on 8/19/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import XCTest
import ViviSwiften
@testable import ViviInterface

class VSClientControllerProtocolTests: XCTestCase {
    
    var moc: NSManagedObjectContext?
    var instance: VSClientControllerProtocol?
    
    override func setUp() {
        super.setUp()
        
        moc = setUpCoreData()
        instance = NSEntityDescription.insertNewObjectForEntityForName("Client", inManagedObjectContext: moc!) as? VIClientMO
    }
    
    override func tearDown() {
        moc = nil
        
        super.tearDown()
    }
    
    let notificationCenter = NSNotificationCenter.defaultCenter()
    let mainQueue = NSOperationQueue.mainQueue()
    
    func testClientWillSendMessageTo() {
        var isReceivedNotification = false
        let observer = notificationCenter.addObserverForName(VIClientChatWillSendMsgNotification, object: nil, queue: mainQueue, usingBlock: {
            (notification) -> Void in
            if let userInfo = notification.userInfo as? [String: AnyObject] {
                if let oldIndex = userInfo["oldIndex"] as? Int {
                    XCTAssertEqual(oldIndex, -1, "old index should be 0")
                } else {
                    XCTFail("notification should has info for \"oldIndex\"")
                }
            }
            isReceivedNotification = true
        })
        
        let receiver = SWAccount(accountName: "test account")
        let message = "test message"
        let date = NSDate()
        let newMessage = instance?.clientWillSendMessageTo(receiver, message: message, timestamp: date)
        if instance is VIClientMO {
            XCTAssertTrue(newMessage is VIMessageMO, "newMessage should be VIMessageMO")
            let messageMO = newMessage as! VIMessageMO
            XCTAssertEqual(messageMO.content, message, "message content doesn't correspond to setting")
            XCTAssertEqual(VIChatMessageDirection(rawValue:messageMO.direction!.integerValue), VIChatMessageDirection.WillTo, "direction wrong")
            XCTAssertEqual(messageMO.timestamp, date, "timestamp doesn't correspond to setting")
            
            let client = instance as! VIClientMO
            XCTAssertEqual(client.chatCount, 1, "chat number wrong")
            XCTAssertEqual(client.chatAtIndex(0)!.lastMessage, message, "chat message doesn't correspond")
        } else {
            XCTFail("no implemented testing for non-VIClientMO VSClientControllerProtocol conformer")
        }
        
        XCTAssertTrue(isReceivedNotification, "should receive notification")
        notificationCenter.removeObserver(observer)
    }
    
    func testClientDidSendMessage() {
        var isReceivedNotification = false
        let observer = notificationCenter.addObserverForName(VIClientChatDidSendMsgNotification, object: nil, queue: mainQueue, usingBlock: {
            (notification) -> Void in
            if let userInfo = notification.userInfo as? [String: AnyObject] {
                if let chatIndex = userInfo["chatIndex"] as? Int {
                    XCTAssertEqual(chatIndex, 0, "chatIndex should be 0")
                } else {
                    XCTFail("notification should has info for \"chatIndex\"")
                }
                if let messageIndex = userInfo["messageIndex"] as? Int {
                    XCTAssertEqual(messageIndex, 0, "messageIndex should be 0")
                } else {
                    XCTFail("notification should has info for \"messageIndex\"")
                }
            }
            isReceivedNotification = true
        })
        
        let receiver = SWAccount(accountName: "test account")
        let message = "test message"
        let date = NSDate()
        let newMessage = instance?.clientWillSendMessageTo(receiver, message: message, timestamp: date)
        
        instance?.clientDidSendMessage(newMessage)
        
        if newMessage is VIMessageMO {
            XCTAssertEqual((newMessage as! VIMessageMO).direction, VIChatMessageDirection.To.rawValue, "wrong direction")
        }
        
        XCTAssertTrue(isReceivedNotification, "should receive notification")
        notificationCenter.removeObserver(observer)
    }
    
    func testClientFailSendMessage() {
        var isReceivedNotification = false
        let observer = notificationCenter.addObserverForName(VIClientChatDidSendMsgNotification, object: nil, queue: mainQueue, usingBlock: {
            (notification) -> Void in
            if let userInfo = notification.userInfo as? [String: AnyObject] {
                if let chatIndex = userInfo["chatIndex"] as? Int {
                    XCTAssertEqual(chatIndex, 0, "chatIndex should be 0")
                } else {
                    XCTFail("notification should has info for \"chatIndex\"")
                }
                if let messageIndex = userInfo["messageIndex"] as? Int {
                    XCTAssertEqual(messageIndex, 0, "messageIndex should be 0")
                } else {
                    XCTFail("notification should has info for \"messageIndex\"")
                }
                XCTAssertNotNil(userInfo["error"], "notification should has info for \"error\"")
            }
            isReceivedNotification = true
        })
        
        let receiver = SWAccount(accountName: "test account")
        let message = "test message"
        let date = NSDate()
        let newMessage = instance?.clientWillSendMessageTo(receiver, message: message, timestamp: date)
        
        instance?.clientFailSendMessage(newMessage, error: VSClientErrorType.ClientUnavaliable)
        
        if newMessage is VIMessageMO {
            XCTAssertEqual((newMessage as! VIMessageMO).direction, VIChatMessageDirection.FailTo.rawValue, "wrong direction")
        }
        
        XCTAssertTrue(isReceivedNotification, "should receive notification")
        notificationCenter.removeObserver(observer)
    }
    
    func testClientDidReceivedMessageFrom() {
        var isReceivedNotification = false
        let observer = notificationCenter.addObserverForName(VIClientChatDidReceiveMsgNotification, object: nil, queue: mainQueue, usingBlock: {
            (notification) -> Void in
            if let userInfo = notification.userInfo as? [String: AnyObject] {
                if let oldIndex = userInfo["oldIndex"] as? Int {
                    XCTAssertEqual(oldIndex, -1, "old index should be 0")
                } else {
                    XCTFail("notification should has info for \"oldIndex\"")
                }
            }
            isReceivedNotification = true
        })
        
        let sender = SWAccount(accountName: "test account")
        let message = "test message"
        let date = NSDate()
        instance?.clientDidReceivedMessageFrom(sender, message: message, timestamp: date)
        if instance is VIClientMO {
            let client = instance as! VIClientMO
            XCTAssertEqual(client.chatCount, 1, "chat number wrong")
            XCTAssertEqual(client.chatAtIndex(0)!.lastMessage, message, "chat message doesn't correspond")
        } else {
            XCTFail("no implemented testing for non-VIClientMO VSClientControllerProtocol conformer")
        }
        
        XCTAssertTrue(isReceivedNotification, "should receive notification")
        notificationCenter.removeObserver(observer)
    }
    
}
