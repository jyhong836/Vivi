//
//  VIChat.swift
//  Vivi
//
//  Created by Junyuan Hong on 7/30/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Foundation
import ViviSwiften

public class VIChat {
    
    public var owner: SWAccount!
    public var buddy: SWAccount!
    public var lastMessage: String = "" {
        willSet {
            NSLog("Set last msg: \(newValue)")
            // TODO: store data to file
        }
    }
    public var lastMessageTime: NSDate? {
        willSet {
            NSLog("Set last time: \(newValue)")
        }
    }
    
    public init(owner: SWAccount, buddy: SWAccount) {
        self.owner = owner
        self.buddy = buddy
    }
    
}
