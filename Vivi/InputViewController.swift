//
//  InputViewController.swift
//  Vivi
//
//  Created by Junyuan Hong on 8/1/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Cocoa
import ViviSwiften

class InputViewController: NSViewController {
    
    var currentClient: SWClient?
    var currentBuddy: SWAccount?

    @IBOutlet var inputTextView: NSTextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func sendButtonClicked(sender: NSButton) {
        if let buddy = currentBuddy {
            // FIXME: Didn't receive any message when fail to send message
            currentClient?.sendMessageToAccount(buddy, message: inputTextView.textStorage?.string)
        }
    }
}
