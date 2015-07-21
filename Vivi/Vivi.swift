//
//  Vivi.swift
//  Vivi
//
//  Created by Junyuan Hong on 7/21/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Cocoa
import ViviSwiften

class Vivi: NSObject, VSVivi {
    
    var clientController: NSObject?
    var isQuitting: Bool { get{return false;} }
}
