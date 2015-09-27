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
                    content: transferTextStorage(inputTextView.textStorage!),
                    attachments: inputTextView.sendingFiles,
                    handler: { (nserr) -> Void in
                        if let nserror = nserr {
                            let err = VSClientErrorType(rawValue: nserror.code)!
                            // process errors
                            switch err {
                            case VSClientErrorType.FileNotFound:
                                fatalError("Not found file")
                            case VSClientErrorType.FileTransferNotSupport:
                                let alert = NSAlert()
                                alert.messageText = "Not suport file transfer."
                                alert.runModal()
                            default:
                                self.inputTextView.textStorage?.setAttributedString(NSAttributedString(string: ""))
                                self.inputTextView.sendingFiles = []
                            }
                        } else {
                            self.inputTextView.textStorage?.setAttributedString(NSAttributedString(string: ""))
                            self.inputTextView.sendingFiles = []
                        }
                    }
                )
            }
        }
    }
    
    func transferTextStorage(storage: NSTextStorage) -> String {
        return storage.transferStringWithAttachments()
    }
    
}
