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
    
//    var isViewLoaded: Bool = false
    
    var currentClient: SWClient? {
        didSet {
            if viewLoaded {
                updateButtonStates()
            }
        }
    }

    @IBOutlet weak var avaterButton: NSButton!
    @IBOutlet weak var connectButton: NSButton!
    @IBOutlet weak var lockButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        updateButtonStates()
    }
    
    private func updateButtonStates() {
        if currentClient != nil {
            avaterButton.enabled = true
            connectButton.enabled = true
            lockButton.enabled = true
        } else {
            avaterButton.enabled = false
            connectButton.enabled = false
            lockButton.enabled = false
        }
    }
    
    @IBAction func loginButtonClicked(sender: AnyObject) {
        if let c = currentClient {
            c.connectWithHandler({ () -> Void in
                // FIXME: Here need error parameter
            })
        }
    }
}
