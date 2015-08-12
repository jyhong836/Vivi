//
//  Message.swift
//  Vivi
//
//  Created by Junyuan Hong on 8/11/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Foundation
import CoreData

//@objc(Message)
public class VIMessageMO: NSManagedObject {

    func setDirection(dir: VIChatMessageDirection) {
        self.direction = NSNumber(integer: dir.rawValue)
    }
    
}
