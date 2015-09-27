//
//  VIGroupMO.swift
//  Vivi
//
//  Created by Junyuan Hong on 8/11/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Foundation
import CoreData

public class VIGroupMO: NSManagedObject {

    var isShouldBeDeleted: Bool = true
    
    public override func awakeFromInsert() {
        isShouldBeDeleted = false
    }
    
}
