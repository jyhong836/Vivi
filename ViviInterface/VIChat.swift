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
    
    internal var account: SWAccount!
    public var lastMessage: String = ""
    
    public init(account: SWAccount) {
        self.account = account
    }
    
}
