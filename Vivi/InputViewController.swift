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
                    handler: { (errType) -> Void in
                    // TODO: Add notification here for error
//                    if errType == VSClientErrorType.ClientUnavaliable {
//                        // TODO: Add notification here for error
//                        NSLog("Attend to send message from unavalible client: %@", (self.currentClient?.account.getFullAccountString())!)
//                    } else if errType == VSClientErrorType.None {
//                    }
                        self.inputTextView.textStorage?.setAttributedString(NSAttributedString(string: ""))
                        self.inputTextView.sendingFiles = []
                    }
                )
//                do {
//                    for filename in inputTextView.sendingFiles {
//                        NSLog("Sending file \(filename)")
//                        // TODO: send file
////                        try currentClient?.fileTransferManager.sendFileTo(buddy, filename: filename, desciption: "")
//                    }
//                } catch {
//                    fatalError("Fail to send file: \(error)")
//                }
            }
        }
    }
    
    func transferTextStorage(storage: NSTextStorage) -> String {
        return storage.transferStringWithAttachments()
    }
    
}
