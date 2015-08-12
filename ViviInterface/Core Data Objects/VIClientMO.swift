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
public class VIClientMO: NSManagedObject {

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
    
    // MARK: Chat access
    
    func updateChatList(withBuddy buddy: VIAccountMO) -> (VIChatMO, oldIndex: Int) {
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
    
    public func getChatWithBuddy(buddy: VIAccountMO) -> VIChatMO? {
        for element in self.chats! {
            let chat = element as! VIChatMO
            if (chat.buddy!.node == buddy.node) && (chat.buddy?.domain == buddy.domain) {
                return chat
            }
        }
        return nil
    }
    
    public func addChatWithBuddy(buddy: VIAccountMO) -> (VIChatMO, isNew: Bool) {
        if let existedChat = getChatWithBuddy(buddy) {
            return (existedChat, false)
        } else {
            let moc = self.managedObjectContext
            let newChat = NSEntityDescription.insertNewObjectForEntityForName("Chat", inManagedObjectContext: moc!) as! VIChatMO
            newChat.owner = self
            newChat.buddy = buddy
            
            return (newChat, true)
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
    
}
