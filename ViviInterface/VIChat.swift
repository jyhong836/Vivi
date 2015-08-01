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
    case From, To, FailTo, None
}

public func == (lhs: VIChat, rhs: VIChat) -> Bool {
    return lhs.owner == rhs.owner && lhs.buddy == rhs.buddy
}

public class VIChat: Equatable {
    
    public var owner: SWAccount!
    public var buddy: SWAccount!
    
    public private(set) var lastMessageDirection: VIChatMessageDirection = .None
    public private(set) var lastMessage: String = "" {
        willSet {
            NSLog("Set last msg: \(newValue)")
            // TODO: store data to file
        }
    }
    public private(set) var lastMessageTime: NSDate? {
        willSet {
            NSLog("Set last time: \(newValue)")
        }
    }
    
    public init(owner: SWAccount, buddy: SWAccount) {
        self.owner = owner
        self.buddy = buddy
    }
    
    public func addMessage(message: String, timestamp: NSDate, direction: VIChatMessageDirection) {
        // TODO: Add message to storage.
        lastMessage = message
        lastMessageTime = timestamp
        lastMessageDirection = direction
    }
}
