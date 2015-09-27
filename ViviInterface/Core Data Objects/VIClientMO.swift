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
public let VIClientDidReceivePresence = "VIClientDidReceivePresence"

public class VIClientMO: NSManagedObject, VSClientControllerProtocol, VSAvatarDelegate {
    
    override public func awakeFromInsert() {
        self.enabled = NSNumber(bool: false)
        self.chats = NSOrderedSet()
        
        let moc = self.managedObjectContext!
        self.roster = NSEntityDescription.insertNewObjectForEntityForName("Roster", inManagedObjectContext: moc) as? VIRosterMO
        roster?.client = self
    }
    
    public override func prepareForDeletion() {
        if enabled!.boolValue {
            let clientMgr = VIClientManager.sharedClientManager
            clientMgr.removeClient(clientMgr.getClient(withAccountName: accountname!))
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
            if chat.buddy != nil &&
                chat.buddy!.node == buddy.nodeString &&
                chat.buddy!.domain == buddy.domainString {
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
                let buddyMO = try VIAccountMO.addAccount(buddy.nodeString, domain: buddy.domainString, managedObjectContext: moc!)
                
                let newChat = NSEntityDescription.insertNewObjectForEntityForName("Chat", inManagedObjectContext: moc!) as! VIChatMO
                newChat.buddy = buddyMO
                let chats = self.mutableOrderedSetValueForKey("chats")
                chats.insertObject(newChat, atIndex: 0)
                
                notificationCenter.postNotificationName(
                    VIClientChatDidAddNotification, object: self, userInfo: ["index": chats.indexOfObject(newChat)])
                
                return (newChat, true)
            } catch {
                fatalError("Fail to add chat with account: \(error)")
            }
        }
    }
    
    /// Add a new temp chat at index 0, without buddy.
    /// WARN: do not save context before setting buddy attribute.
    public func addTempChat() -> VIChatMO {
        let moc = self.managedObjectContext
        let newChat = NSEntityDescription.insertNewObjectForEntityForName("Chat", inManagedObjectContext: moc!) as! VIChatMO
        let chats = self.mutableOrderedSetValueForKey("chats")
        chats.insertObject(newChat, atIndex: 0)
        
        notificationCenter.postNotificationName(
            VIClientChatDidAddNotification, object: self, userInfo: ["index": chats.indexOfObject(newChat)])
        
        return newChat
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
    
    public func clientWillSendMessageTo(receiver: SWAccount, message: String, attachments: [SWFileTransfer]?, timestamp date: NSDate) -> AnyObject {
        let (lastchat, oldIndex) = updateChats(withBuddy: receiver)
        let newMessage = lastchat.addMessage(message, attachments: attachments, timestamp: date, direction: .WillTo)
        notificationCenter.postNotificationName(VIClientChatWillSendMsgNotification, object: lastchat, userInfo: ["oldIndex": oldIndex])
        
        return newMessage
    }
    
    public func clientDidSendMessage(message: AnyObject) {
        let msgMO = message as! VIMessageMO
        msgMO.setDirection(.To)
        
        let lastchat = msgMO.chat!
        let updatedIndex = lastchat.indexOfMessage(msgMO)
        let chatIndex: Int = (chats?.indexOfObject(lastchat))!
        
        notificationCenter.postNotificationName(VIClientChatDidSendMsgNotification, object: lastchat, userInfo: ["chatIndex": chatIndex, "messageIndex": updatedIndex])
    }
    
    public func clientFailSendMessage(message: AnyObject, error: VSClientErrorType) {
        let msgMO = message as! VIMessageMO
        msgMO.setDirection(.FailTo)
        
        let lastchat = msgMO.chat!
        let updatedIndex = lastchat.indexOfMessage(msgMO)
        let chatIndex: Int = (chats?.indexOfObject(lastchat))!
        
        notificationCenter.postNotificationName(VIClientChatDidSendMsgNotification, object: lastchat, userInfo: ["chatIndex": chatIndex, "messageIndex": updatedIndex, "error": error.rawValue])
    }
    
    public func clientDidReceivedMessageFrom(sender: SWAccount, message: String, timestamp date: NSDate) {
        if sender.nodeString.isEmpty && !sender.domainString.isEmpty {
            let alert = NSAlert()
            alert.messageText = "Message from domain: \"\(sender.domainString)\""
            alert.addButtonWithTitle("OK")
            alert.runModal()
        } else {
            let (lastchat, oldIndex) = updateChats(withBuddy: sender)
            // TODO: need set up attachemnts from received message.
            lastchat.addMessage(message, attachments: nil, timestamp: date, direction: .From)
            notificationCenter.postNotificationName(VIClientChatDidReceiveMsgNotification, object: lastchat, userInfo: ["oldIndex": oldIndex])
        }
    }
    
    public func clientDidReceivePresence(client: SWClient, fromAccount account: SWAccount, currentPresence presenceType: Int32, currentShow showType: Int32, currentStatus status: String) {
        NSLog("client(\(client.account.accountString)) did receive presence from \(account.accountString)/\(account.resourceString): \(SWPresenceType(rawValue: presenceType)?.toString()), \(SWPresenceShowType(rawValue: showType)?.toString()), \(status))")
        print("* Resource *")
        for res in account.resources {
            print("+ \(res)")
        }
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            do {
                let accountMO = try VIAccountMO.addAccount(account.nodeString, domain: account.domainString, managedObjectContext: self.managedObjectContext!)
                
                if let presence = SWPresenceType(rawValue: presenceType) {
                    accountMO.presence = presence
                } else {
                    fatalError("Receive unexpected presence code: \(presenceType)")
                }
                if let show = SWPresenceShowType(rawValue: showType) {
                    accountMO.presenceshow = show
                } else {
                    fatalError("Receive unexpected presence show code: \(showType)")
                }
                accountMO.status = status
                self.notificationCenter.postNotificationName(VIClientDidReceivePresence, object: accountMO, userInfo: nil)
            } catch {
                fatalError("Receive presence from account cause unexpected error when try to add account:\n \(error)")
            }
        }
    }
    
    public func clientShouldTrustCerficiate(subject: String) -> Bool {
        let alert = NSAlert()
        alert.messageText = "Untrusted certificate: \(subject)"
        alert.addButtonWithTitle("Cancel")
        alert.addButtonWithTitle("Trust")
        let answer = alert.runModal()
        if answer == NSAlertFirstButtonReturn {
            return false
        } else {
            return true
        }
    }
    
    // MARK: - Conform avatar delegate
    
    public func account(account: SWAccount!, didChangeAvatar avatarData: NSData!) {
        if let accountMO = VIAccountMO.getAccount(account.nodeString, domain: account.domainString, managedObjectContext: self.managedObjectContext!) {
            accountMO.avatar = avatarData
        }
    }
    
}
