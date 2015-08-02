//
//  VIChat.swift
//  Vivi
//
//  Created by Junyuan Hong on 7/30/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Foundation
import ViviSwiften

public enum VIChatMessageDirection {
    case From, To, WillTo, FailTo, None
}

public class VIChatMessage {
    public var content: String
    public var timestamp: NSDate
    public var direction: VIChatMessageDirection
    init(content: String, timestamp: NSDate, direction: VIChatMessageDirection) {
        self.content = content
        self.timestamp = timestamp
        self.direction = direction
    }
}

public func == (lhs: VIChat, rhs: VIChat) -> Bool {
    return lhs.owner == rhs.owner && lhs.buddy == rhs.buddy
}

public class VIChat: Equatable {
    
    public var owner: SWAccount!
    public var buddy: SWAccount!
    
    public init(owner: SWAccount, buddy: SWAccount) {
        self.owner = owner
        self.buddy = buddy
    }
    
    // MARK: Last message
    public var lastMessage: String {
        get {
            if messageArray.count > 0 {
                return messageArray[messageArray.count - 1].content
            } else {
                return ""
            }
        }
    }
    public var lastMessageTime: NSDate? {
        get {
            if messageArray.count > 0 {
                return messageArray[messageArray.count - 1].timestamp
            } else {
                return nil
            }
        }
    }
    public var lastMessageDirection: VIChatMessageDirection {
        get {
            if messageArray.count > 0 {
                return messageArray[messageArray.count - 1].direction
            } else {
                return .None
            }
        }
    }
    
    // MARK: Arrary storage
    private(set) var messageArray: [VIChatMessage] = []
    
    /// Add a new message to message array
    public func addMessage(content: String, timestamp: NSDate, direction: VIChatMessageDirection) {
        // TODO: Add message to file storage.
        messageArray.append( VIChatMessage(content: content, timestamp: timestamp, direction: direction) )
    }
    
    /// Update or add a new message, and return updated message index or -1 (new message)
    func updateMessage(content: String, timestamp: NSDate, direction: VIChatMessageDirection) -> Int {
        let index = messageArray.indexOf { (msg) -> Bool in
            msg.content == content && msg.timestamp.compare(timestamp) == .OrderedSame
        }
        if let i = index {
            updateMessageAtIndex(Int(i), content: content, timestamp: timestamp, direction: direction)
            return Int(i)
        } else {
            addMessage(content, timestamp: timestamp, direction: direction)
            return -1
        }
    }
    
    public func updateMessageAtIndex(index: Int, content: String? = nil, timestamp: NSDate? = nil, direction: VIChatMessageDirection? = nil) {
        if index >= 0 && index < messageCount {
            if let cnt = content {
                messageArray[index].content = cnt
            }
            if let ts = timestamp {
                messageArray[index].timestamp = ts
            }
            if let dir = direction {
                messageArray[index].direction = dir
            }
        }
    }
    
    public var messageCount: Int {
        get {
            return messageArray.count
        }
    }
    
//    public func messageStringAtIndex(index: Int) -> String? {
//        if index >= 0 && index < messageCount {
//            return messageArray[index].message
//        } else {
//            return nil
//        }
//    }
//    public func messageTimestampAtIndex(index: Int) -> NSDate? {
//        if index >= 0 && index < messageCount {
//            return messageArray[index].timestamp
//        } else {
//            return nil
//        }
//    }
//    public func messageDirectionAtIndex(index: Int) -> VIChatMessageDirection? {
//        if index >= 0 && index < messageCount {
//            return messageArray[index].direction
//        } else {
//            return nil
//        }
//    }
    public func messageAtIndex(index: Int) -> VIChatMessage? {
        if index >= 0 && index < messageCount {
            return messageArray[index]
        } else {
            return nil
        }
    }
}
