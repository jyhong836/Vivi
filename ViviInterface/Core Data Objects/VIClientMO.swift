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

// MARK: Client chat notificatons
public let VIClientChatDidAddNotification = "VIClientChatDidAddNotification"
public let VIClientChatWillSendMsgNotification = "VIClientChatWillSendMsgNotification"
public let VIClientChatDidSendMsgNotification = "VIClientChatDidSendMsgNotification"
public let VIClientChatDidReceiveMsgNotification = "VIClientChatDidReceiveMsgNotification"

//@objc(Client)
public class VIClientMO: NSManagedObject, VSClientControllerProtocol {
    
    override public func awakeFromInsert() {
        self.enabled = NSNumber(bool: false)
        self.chats = NSOrderedSet()
        
        let moc = self.managedObjectContext!
        self.roster = NSEntityDescription.insertNewObjectForEntityForName("Roster", inManagedObjectContext: moc) as? VIRosterMO
        roster?.client = self
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
    
    // MARK: - Chat access
    
    func updateChats(withBuddy buddy: SWAccount) -> (VIChatMO, oldIndex: Int) {
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
            let moc = self.managedObjectContext
            do {
                let buddyMO = try VIAccountMO.addAccount(buddy.getNodeString(), domain: buddy.getDomainString(), managedObjectContext: moc!)
                
                let newChat = NSEntityDescription.insertNewObjectForEntityForName("Chat", inManagedObjectContext: moc!) as! VIChatMO
                newChat.owner = self
                newChat.buddy = buddyMO
                
                notificationCenter.postNotificationName(
                    VIClientChatDidAddNotification, object: self, userInfo: ["index": 0])
                
                return (newChat, true)
            } catch {
                fatalError("Fail to add chat with account: \(error)")
            }
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
    
//    public func removeChatAtIndex(index: Int) {
//        if index >= 0 && index < chatCount {
//            let chats = self.mutableOrderedSetValueForKey("chats")
//            chats.removeObjectAtIndex(index)
//        }
//    }
    
    // MARK: - Implement VSClientControllerProtocol
    let notificationCenter = NSNotificationCenter.defaultCenter()
    
    public func clientWillSendMessageTo(receiver: SWAccount!, message: String!, timestamp date: NSDate!) -> AnyObject! {
        let (lastchat, oldIndex) = updateChats(withBuddy: receiver)
        let newMessage = lastchat.addMessage(message, timestamp: date, direction: .WillTo)
        notificationCenter.postNotificationName(VIClientChatWillSendMsgNotification, object: lastchat, userInfo: ["oldIndex": oldIndex])
        
        return newMessage
    }
    
    public func clientDidSendMessage(message: AnyObject!) {
        let msgMO = message as! VIMessageMO
        msgMO.setDirection(.To)
        
        let lastchat = msgMO.chat!
        let updatedIndex = lastchat.indexOfMessage(msgMO)
        let chatIndex: Int = (chats?.indexOfObject(lastchat))!
        
        notificationCenter.postNotificationName(VIClientChatDidSendMsgNotification, object: lastchat, userInfo: ["chatIndex": chatIndex, "messageIndex": updatedIndex])
    }
    
    public func clientFailSendMessage(message: AnyObject!, error: VSClientErrorType) {
        let msgMO = message as! VIMessageMO
        msgMO.setDirection(.FailTo)
        
        let lastchat = msgMO.chat!
        let updatedIndex = lastchat.indexOfMessage(msgMO)
        let chatIndex: Int = (chats?.indexOfObject(lastchat))!
        
        notificationCenter.postNotificationName(VIClientChatDidSendMsgNotification, object: lastchat, userInfo: ["chatIndex": chatIndex, "messageIndex": updatedIndex, "error": error.rawValue])
    }
    
    public func clientDidReceivedMessageFrom(sender: SWAccount!, message: String!, timestamp date: NSDate!) {
        let (lastchat, oldIndex) = updateChats(withBuddy: sender)
        lastchat.addMessage(message, timestamp: date, direction: .From)
        notificationCenter.postNotificationName(VIClientChatDidReceiveMsgNotification, object: lastchat, userInfo: ["oldIndex": oldIndex])
    }
    
}
