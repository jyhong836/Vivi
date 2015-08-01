//
//  ChatMessageViewController.swift
//  Vivi
//
//  Created by Junyuan Hong on 8/2/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Cocoa
import ViviInterface

class ChatMessageViewController: NSViewController {

    @IBOutlet weak var messageTableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    // MARK: API for update chat table view
    
    func updateChatView(chat: VIChat) {
        switch chat.lastMessageDirection {
        case .From:
            addInMessage(chat.lastMessage, timestamp: chat.lastMessageTime!)
        case .To:
            addInMessage(chat.lastMessage, timestamp: chat.lastMessageTime!)
        default:
            break
        }
    }
    
    func addInMessage(message: String, timestamp: NSDate) {
        // TODO: Code add
    }
    
    func addOutMessage(message: String, timestamp: NSDate) {
        // TODO: Code add
    }
}
