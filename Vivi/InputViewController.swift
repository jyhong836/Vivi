//
//  InputViewController.swift
//  Vivi
//
//  Created by Junyuan Hong on 8/1/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Cocoa
import ViviSwiften
import ViviInterface

class InputViewController: NSViewController {
    
    var currentChat: VIChatMO?
    
    var currentClient: SWClient? {
        get {
            return currentChat?.owner?.swclient
        }
    }
    var currentBuddy: SWAccount? {
        get {
            return currentChat?.buddy?.swaccount
        }
    }

    @IBOutlet var inputTextView: InputTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
//        inputTextView.importsGraphics = true
//        inputTextView.registerForDraggedTypes([NSFilenamesPboardType])
    }
    
    @IBAction func sendButtonClicked(sender: NSButton) {
        if let buddy = currentBuddy {
            if inputTextView.textStorage?.length > 0 {
                currentClient?.sendMessageToAccount(buddy,
                    content: inputTextView.textStorage!.transferedStringWithAttachments(),
                    attachments: inputTextView.sendingFiles,
                    handler: { (nserr) -> Void in
                        if let nserror = nserr {
                            let err = VSClientErrorType(rawValue: nserror.code)!
                            // process errors
                            switch err {
                            case .None:
                                self.inputTextView.textStorage?.setAttributedString(NSAttributedString(string: ""))
                            default:
                                sender.presentError(nserror)
                            }
                        } else {
                            self.inputTextView.textStorage?.setAttributedString(NSAttributedString(string: ""))
                        }
                    }
                )
            }
        }
    }
    
}
