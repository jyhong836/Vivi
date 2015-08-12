//
//  Chat.swift
//  Vivi
//
//  Created by Junyuan Hong on 8/11/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Foundation
import CoreData

//@objc(Chat)
public class VIChatMO: NSManagedObject {

    public override func awakeFromInsert() {
        self.createdtime = NSDate()
        self.updatedtime = NSDate()
        self.messages = NSOrderedSet()
    }
    
    // MARK: Message access
    
    public var lastMessage: VIMessageMO {
        get {
            return (messages?.lastObject)! as! VIMessageMO
        }
    }
    
    /// Add a new message
    public func addMessage(content: String, timestamp: NSDate, direction: VIChatMessageDirection) -> VIMessageMO {
        let moc = self.managedObjectContext
        let message = NSEntityDescription.insertNewObjectForEntityForName("Message", inManagedObjectContext: moc!) as! VIMessageMO
        message.content = content
        message.timestamp = timestamp
        message.direction = NSNumber(integer: direction.rawValue)
        message.chat = self
        
        return message
    }
    
//    /// Update an existed message with new direction.
//    func updateMessage(message: VIMessageMO, newDirection direction: VIChatMessageDirection) {
//    }
    
    public func indexOfMessage(message: VIMessageMO) -> Int {
        return (messages?.indexOfObject(message))!
    }
    
    public var messageCount: Int {
        get {
            return messages!.count
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
