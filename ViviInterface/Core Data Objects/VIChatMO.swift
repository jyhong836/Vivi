//
//  Chat.swift
//  Vivi
//
//  Created by Junyuan Hong on 8/11/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Foundation
import CoreData
import ViviSwiften

public enum VIChatMessageDirection: Int {
    case From, To, WillTo, FailTo, None
}

public class VIChatMO: NSManagedObject {

    public override func awakeFromInsert() {
        self.createdtime = NSDate()
        self.updatedtime = self.createdtime
        self.messages = NSOrderedSet()
    }
    
    // MARK: - Unread message count
    
    /// Mark whether the chat is being represented in GUI view.
    public var isRepresented: Bool = false {
        didSet {
            if (isRepresented) {
                owner!.unreadcount = owner!.unreadcount!.integerValue - unreadcount!.integerValue
                unreadcount = 0
            }
        }
    }
    
    /// Indicate whether chat has unread message. (read-only)
    var hasUnreadMessage: Bool {
        get {
            return unreadcount?.integerValue > 0
        }
    }
    
    /// Add unread message counnt if chat is not represented.
    func addUnreadCount() {
        if !isRepresented {
            unreadcount = unreadcount!.integerValue + 1
            owner!.unreadcount = owner!.unreadcount!.integerValue + 1
        }
    }
    
    // MARK: - Message access
    
    /// Last added message. (read-only)
    public var lastMessage: String {
        get {
            if let msgs = messages {
                if let lastone = (msgs.lastObject as? VIMessageMO) {
                    return lastone.content!
                }
            }
            return ""
        }
    }
    
    /// Add a new message
    public func addMessage(content: String, attachments: [SWFileTransfer]?, timestamp: NSDate, direction: VIChatMessageDirection) -> VIMessageMO {
        let moc = self.managedObjectContext
        let message = NSEntityDescription.insertNewObjectForEntityForName("Message", inManagedObjectContext: moc!) as! VIMessageMO
        message.content = content
        message.timestamp = timestamp
        message.direction = NSNumber(integer: direction.rawValue)
        message.chat = self
        message.addAttachments(attachments)
        
        addUnreadCount()
        
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            self.updatedtime = NSDate()
        }
        
        return message
    }
    
    public func indexOfMessage(message: VIMessageMO) -> Int {
        return (messages?.indexOfObject(message))!
    }
    
    public var messageCount: Int {
        get {
            if let msgs = messages {
                return msgs.count
            } else {
                return 0
            }
        }
    }
    
    public func messageAtIndex(index: Int) -> VIMessageMO? {
        if index >= 0 && index < messageCount {
            return (messages![index] as! VIMessageMO)
        } else {
            return nil
        }
    }
}
