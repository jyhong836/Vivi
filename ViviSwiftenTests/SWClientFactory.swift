//
//  SWClientFactory.swift
//  Vivi
//
//  Created by Junyuan Hong on 7/31/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Foundation
import ViviSwiften

class SWClientFactory {
    
    private static var _eventLoop: SWEventLoop?
    static var eventLoop: SWEventLoop {
        get {
            if _eventLoop == nil {
                _eventLoop = SWEventLoop()
            }
            return _eventLoop!
        }
    }
    
    static let clientAccountString = ["jyhong@xmpp.jp/testResource", "jyhong1@xmpp.jp/testResource"]
    static let clientPasswdString = ["jyhong123", "jyhong123"]
    
    static func createClient(index: Int) -> SWClient {
        let c =  SWClient(account: SWAccount(accountName: clientAccountString[index]), password: clientPasswdString[index], eventLoop: eventLoop)
        return c
    }
}
