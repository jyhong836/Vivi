//
//  TSVivi.swift
//  Vivi
//
//  Created by Junyuan Hong on 7/23/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Cocoa
import ViviSwiften

class TSVivi: NSObject, VSVivi {
    
    // MARK: VSVivi implementation
    
    var clientController: VSClientController?
    var isQuitting: Bool = false
    
    override init() {
        super.init()
//        setSharedVivi(self)
        // TODO: do things to init controllers
        //        clientController!.
        clientController = TSClientController()
    }
    
}
