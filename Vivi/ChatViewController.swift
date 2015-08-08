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
            inputViewController?.currentClient = currentClient
        }
    }
    var currentChat: VIChat? {
        didSet {
            inputViewController?.currentBuddy = currentChat?.buddy
            chatMessageViewController?.currentChat = currentChat
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
            inputViewController?.currentClient = currentClient
        } else if segue.identifier == "ChatMessageViewSegue" {
            chatMessageViewController = segue.destinationController as? ChatMessageViewController
        }
    }
    
//    func chatDidUpdate(chat: VIChat, withNewMessageAtIndex index: Int) {
//        if chat == currentChat {
//            // TODO: do something
//            chatMessageViewController?.chatDidAddMessage()
//        }
//    }
    
    /// Update chat view.
    ///
    /// - Parameter index: If index is validate, then update specific message. If index is -1,
    /// add a new message, which is default.
    func chatDidUpdate(chat: VIChat, updateMessageAtIndex index: Int = -1) {
        if chat == currentChat {
            if index >= 0 && index < chat.messageCount {
                chatMessageViewController?.chatDidUpdateMessageAtIndex(index)
            } else if index == -1 {
                chatMessageViewController?.chatDidAddMessage()
            } else {
                assertionFailure("Unexpected message index")
            }
        }
    }
}
