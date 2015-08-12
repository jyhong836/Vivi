//
//  VIClientManagerProtocol.swift
//  Vivi
//
//  Created by Junyuan Hong on 7/26/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import ViviSwiften

protocol VIClientManagerProtocol {
    func addClient(managedObject: VIClientMO) throws -> SWClient?
    func addClient(withAccountName account: String!, andPasswd passwd: String!) throws -> SWClient?
    func removeClient(client: SWClient?)
    func removeAllClient()
    
    func getClient(withAccountName name: String) -> SWClient?
    
    func currentIndexOfClient(client: SWClient?) -> Int?
    func currentIndexOfClient(withAccountName name: String) -> Int?
    
    var clientCount: Int { get }
    var maxClientCount: Int { get }
}
