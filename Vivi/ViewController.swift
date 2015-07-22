//
//  ViewController.swift
//  Vivi
//
//  Created by Junyuan Hong on 7/21/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Cocoa
import ViviSwiften

class ViewController: NSViewController {
    
    @IBOutlet weak var messageTextField: NSScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func connectButton(sender: NSButton) {
        vivi.clientController.client.connect()
    }

    @IBAction func sendMessageButton(sender: NSButton) {
        // TODO: add send message code
//        vivi.clientController.client.sendMessageTo(account, message: messageTextField)
    }
    
}

