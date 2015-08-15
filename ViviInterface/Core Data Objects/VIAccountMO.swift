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
    
    public var accountString: String {
        get {
            return "\(node!)@\(domain!)"
        }
    }
    
    public var swaccount: SWAccount? {
        get {
            return SWAccount(accountName: accountString)
        }
        set {
            self.node = newValue?.getNodeString()
            self.domain = newValue?.getDomainString()
        }
    }

}
