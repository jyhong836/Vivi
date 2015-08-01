//
//  ChatViewController.swift
//  Vivi
//
//  Created by Junyuan Hong on 8/1/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Cocoa
import ViviSwiften
import ViviInterface

class ChatViewController: NSViewController {
    
    var currentClient: SWClient?
    var currentChat: VIChat? {
        didSet {
            inputViewController?.currentBuddy = currentChat?.buddy
        }
    }
    
    var inputViewController: InputViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "InputViewSegue" {
            inputViewController = segue.destinationController as? InputViewController
            inputViewController?.currentClient = currentClient
        }
    }
    
    func chatDidUpdate(chat: VIChat) {
        if chat == currentChat {
            // TODO: do something
        }
    }
}
