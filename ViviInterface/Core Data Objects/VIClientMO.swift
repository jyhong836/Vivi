//
//  Client.swift
//  Vivi
//
//  Created by Junyuan Hong on 8/11/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Foundation
import CoreData
import ViviSwiften

//@objc(Client)
public class VIClientMO: NSManagedObject, VSChatListControllerProtocol {

//    lazy var client: SWClient? = {
//        guard self.account != nil else {
//            NSLog("account is nil, when attempt to access client")
//            abort()
//        }
//        guard self.password != nil else {
//            NSLog("password is nil, when attempt to access client")
//            abort()
//        }
//        return SWClient(account: SWAccount(accountName: self.account?.account.getAccountString()), password: self.password, eventLoop: VIClientManager.sharedClientManager.eventLoop)
//    }()
    
    override public func awakeFromInsert() {
        self.enabled = NSNumber(bool: false)
        self.chats = NSOrderedSet()
    }
    
    // MARK: Chat selected delegate
    // FIXME: remove the delegate in future. Use Notification instead
    public var chatDelegate: VIChatDelegate?
    
    public var selectedChatIndex: Int = -1 {
        didSet {
            if selectedChatIndex >= 0 && selectedChatIndex < chats!.count {
                let chat: VIChatMO = chats![selectedChatIndex] as! VIChatMO
                chatDelegate?.chatIsSelected(chat)
            }
        }
    }
    
    // MARK: Chat access
    
    func updateChatList(withBuddy buddy: SWAccount) -> (VIChatMO, oldIndex: Int) {
        // Try to add chat
        let (lastChat, isNew) = addChatWithBuddy(buddy)
        var index = 0
        if !isNew {
            let chats = self.mutableOrderedSetValueForKey("chats")
            index = chats.indexOfObject(lastChat)
            chats.moveObjectsAtIndexes(NSIndexSet(index: index), toIndex: 0)
        } else {
            index = -1
        }
        return (lastChat, index)
    }
    
    public func getChatWithBuddy(buddy: SWAccount) -> VIChatMO? {
        for element in self.chats! {
            let chat = element as! VIChatMO
            if (chat.buddy!.node == buddy.getNodeString()) && (chat.buddy!.domain == buddy.getDomainString()) {
                return chat
            }
        }
        return nil
    }
    
    public func addChatWithBuddy(buddy: SWAccount) -> (VIChatMO, isNew: Bool) {
        if let existedChat = getChatWithBuddy(buddy) {
            return (existedChat, false)
        } else {
            let buddyMO = insertAccountFromSWAccount(buddy)
            
            let moc = self.managedObjectContext
            let newChat = NSEntityDescription.insertNewObjectForEntityForName("Chat", inManagedObjectContext: moc!) as! VIChatMO
            newChat.owner = self
            newChat.buddy = buddyMO
            
            notificationCenter.postNotificationName(
                VIChatListChatDidAddNotification, object: self, userInfo: ["index": 0])
            
            return (newChat, true)
        }
    }
    
    public var chatCount: Int {
        get {
            return (chats!.count)
        }
    }
    
    public func chatAtIndex(index: Int) -> VIChatMO? {
        if let chats = self.chats {
            if index >= 0 && index < chats.count {
                return chats[index] as? VIChatMO
            }
        }
        return nil
    }
    
    func insertAccountFromSWAccount(swaccount: SWAccount) -> VIAccountMO {
        let account = NSEntityDescription.insertNewObjectForEntityForName("Account", inManagedObjectContext: self.managedObjectContext!) as! VIAccountMO
        account.swaccount = swaccount
        
//        account.chat = self
        // FIXME: set up group and resources
        
        return account
    }
    
    // MARK: Implement VSChatListControllerProtocol
    let notificationCenter = NSNotificationCenter.defaultCenter()
    
    public func clientWillSendMessageTo(receiver: SWAccount!, message: String!, timestamp date: NSDate!) -> AnyObject! {
        let (lastchat, oldIndex) = updateChatList(withBuddy: receiver)
        let newMessage = lastchat.addMessage(message, timestamp: date, direction: .WillTo)
        notificationCenter.postNotificationName(VIChatListChatWillSendNotification, object: lastchat, userInfo: ["oldIndex": oldIndex])
        
        return newMessage
    }
    
    public func clientDidSendMessage(message: AnyObject!) {
        let msgMO = message as! VIMessageMO
        msgMO.setDirection(.To)
        
        let lastchat = msgMO.chat!
        let updatedIndex = lastchat.indexOfMessage(msgMO)
        let chatIndex: Int = (chats?.indexOfObject(lastchat))!
        
        notificationCenter.postNotificationName(VIChatListChatDidSendNotification, object: lastchat, userInfo: ["chatIndex": chatIndex, "messageIndex": updatedIndex])
    }
    
    public func clientFailSendMessage(message: AnyObject!, error: VSClientErrorType) {
        let msgMO = message as! VIMessageMO
        msgMO.setDirection(.FailTo)
        
        let lastchat = msgMO.chat!
        let updatedIndex = lastchat.indexOfMessage(msgMO)
        let chatIndex: Int = (chats?.indexOfObject(lastchat))!
        
        notificationCenter.postNotificationName(VIChatListChatDidSendNotification, object: lastchat, userInfo: ["chatIndex": chatIndex, "messageIndex": updatedIndex, "error": error.rawValue])
    }
    
    public func clientDidReceivedMessageFrom(sender: SWAccount!, message: String!, timestamp date: NSDate!) {
        let (lastchat, oldIndex) = updateChatList(withBuddy: sender)
        lastchat.addMessage(message, timestamp: date, direction: .From)
        notificationCenter.postNotificationName(VIChatListChatDidReceiveNotification, object: lastchat, userInfo: ["oldIndex": oldIndex])
    }
    
}
