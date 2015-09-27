//
//  VIAttachmentMO.swift
//  Vivi
//
//  Created by Junyuan Hong on 9/8/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Foundation
import CoreData
import ViviSwiften

public class VIAttachmentMO: NSManagedObject {
    
    public var fileTransfer: SWFileTransfer? {
        didSet {
            if let ft = fileTransfer {
                filename = ft.filename
            }
        }
    }

    public override func awakeFromInsert() {
        // TODO: Use custom state number.
        state = NSNumber(int: 0)
    }
    
}
