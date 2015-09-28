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
    
    var currentClient: SWClient? {
        didSet {
//            inputViewController?.currentClient = currentClient
        }
    }
    var currentChat: VIChatMO? {
        didSet {
            // FIXME: Should pass swaccount or accountmo？
//            inputViewController?.currentBuddy = currentChat?.buddy?.swaccount
            chatMessageViewController?.currentChat = currentChat
            inputViewController?.currentChat = currentChat
        }
    }
    
    var inputViewController: InputViewController?
    var chatMessageViewController: ChatMessageViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "InputViewSegue" {
            inputViewController = segue.destinationController as? InputViewController
//            inputViewController?.currentClient = currentClient
        } else if segue.identifier == "ChatMessageViewSegue" {
            chatMessageViewController = segue.destinationController as? ChatMessageViewController
        }
    }
}
