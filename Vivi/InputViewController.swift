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
            if inputTextView.textStorage?.length > 0 {
                currentClient?.sendMessageToAccount(buddy,
                    message: inputTextView.textStorage?.string,
                    handler: { (errType) -> Void in
                    // TODO: Add notification here for error
//                    if errType == VSClientErrorType.ClientUnavaliable {
//                        // TODO: Add notification here for error
//                        NSLog("Attend to send message from unavalible client: %@", (self.currentClient?.account.getFullAccountString())!)
//                    } else if errType == VSClientErrorType.None {
//                    }
                        self.inputTextView.textStorage?.setAttributedString( NSAttributedString(string: ""))
                    }
                )
            }
        }
    }
}
