//
//  SwiftenTypeDefine.swift
//  Vivi
//
//  Created by Junyuan Hong on 7/26/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Foundation

// MARK: Swiften types
enum SWPresenceType: Int32 {
    case Available, Error, Probe, Subscribe, Subscribed, Unavailable, Unsubscribe, Unsubscribed
}
let SWPresenceTypeStringDict: [SWPresenceType: String] = [.Available: "Available", .Error: "Error", .Probe: "Probe", .Subscribe: "Subscribe", .Subscribed: "Subscribed", .Unavailable: "Unavailable", .Unsubscribe: "Unsubscribe", .Unsubscribed: "Unsubscribed"]

enum SWPresenceShowType: Int32 {
    case Online, Away, FFC, XA, DND, None
}
let SWPresenceShowTypeStringDict: [SWPresenceShowType: String] = [.Online: "Online", .Away: "Away", .FFC:"FFC", .XA: "XA", .DND: "DND", .None:"None"]
