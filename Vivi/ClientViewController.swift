//
//  ClientViewController.swift
//  Vivi
//
//  Created by Junyuan Hong on 7/31/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Cocoa
import ViviSwiften

class ClientViewController: NSViewController {
    
    var currentClient: SWClient?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func loginButtonClicked(sender: AnyObject) {
        if let c = currentClient {
            c.connect()
        }
    }
}
