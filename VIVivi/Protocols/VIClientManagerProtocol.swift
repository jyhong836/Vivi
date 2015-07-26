//
//  VIClientManagerProtocol.swift
//  Vivi
//
//  Created by Junyuan Hong on 7/26/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Cocoa
import ViviSwiften

public typealias ClientIndex = Int

protocol VIClientManagerProtocol {
//    static func getShared() -> VIClientManagerProtocol
    
    // FIXME: should not use index to access client?
    func addClient(withAccount account: SWAccount, andPasswd passwd: String!) -> ClientIndex?
    func addClient(withAccountName account: String!, andPasswd passwd: String!) -> ClientIndex?
    
    func removeClientAtIndex(index: ClientIndex?)
    func removeClient(client: SWClient?)
    
    func getClientAtIndex(index: ClientIndex?) -> SWClient?
    func indexOfClient(client: SWClient?) -> ClientIndex?
    
    func getClientCount() -> Int
    var maxClientCount: Int { get }
}
