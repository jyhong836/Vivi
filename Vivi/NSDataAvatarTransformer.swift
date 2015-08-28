//
//  NSDataAvatarTransformer.swift
//  Vivi
//
//  Created by Junyuan Hong on 8/28/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Cocoa

class NSDataAvatarTransformer: NSValueTransformer {

    override func transformedValue(value: AnyObject?) -> AnyObject? {
        if value == nil {
            return NSImage(named: "NSUserGuest")
        }
        if let data = value as? NSData {
            return NSImage(data: data)
        } else {
            fatalError("Not a NSData for transformer")
        }
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return false
    }
    
    override class func transformedValueClass() -> AnyClass {
        return NSData.self
    }
    
}
