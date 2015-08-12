//
//  Account.swift
//  Vivi
//
//  Created by Junyuan Hong on 8/11/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Foundation
import CoreData
import ViviSwiften

//@objc(Account)
public class VIAccountMO: NSManagedObject {

//    lazy var account: SWAccount = {
//        guard self.node != nil else {
//            NSLog("node is nil when attempt to access account.")
//            abort()
//        }
//        guard self.domain != nil else {
//            NSLog("node is nil when attempt to access account.")
//            abort()
//        }
//        return SWAccount(accountName: "\(self.node)@\(self.domain)")
//    }()
    
    public var accountString: String {
        get {
            return "\(node)@\(domain)"
        }
    }
    
    public var swaccount: SWAccount? {
        didSet {
            self.node = swaccount?.getNodeString()
            self.domain = swaccount?.getDomainString()
        }
    }

}
