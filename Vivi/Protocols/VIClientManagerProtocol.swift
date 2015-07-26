//
//  VIClientManagerProtocol.swift
//  Vivi
//
//  Created by Junyuan Hong on 7/26/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Cocoa
import ViviSwiften

typealias ClientIndex = Int

protocol VIClientManagerProtocol {
    var clientList: [SWClient!]! { get }
    
    static func getShared() -> VIClientManagerProtocol
    
    func addClient(withAccount account: SWAccount, andPasswd passwd: String!) -> ClientIndex?
    func addClient(withAccountName account: String!, andPasswd passwd: String!) -> ClientIndex?
    
    func getClient(atIndex index: ClientIndex) -> SWClient?
    func indexOfClient(client: SWClient) -> ClientIndex?
}
