//
//  Attachment.swift
//  Vivi
//
//  Created by Junyuan Hong on 9/8/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Foundation
import CoreData

public class VIAttachmentMO: NSManagedObject {

    public override func awakeFromInsert() {
        // TODO: Use custom state number.
        state = NSNumber(int: 0)
    }
    
}
