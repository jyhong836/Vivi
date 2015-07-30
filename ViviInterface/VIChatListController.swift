//
//  VIChatListController.swift
//  Vivi
//
//  Created by Junyuan Hong on 7/30/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Foundation
import ViviSwiften

//enum VIChatListError: ErrorType {
//    case SendMessageFromUndefinedChat
//}

/// VIChatListController is binded to one SWClient
public class VIChatListController: VSChatListControllerProtocol {
    
    public var chatDelegate: VIChatDelegate?
    
    public var chatList: [VIChat] = []
    
    @objc public func clientDidReceivedMessage(receiver: SWClient!, from sender: SWAccount!, message: String!, timestamp: NSDate!) {
        var lastchat = updateChatList(receiver, buddy: sender, message: message, timestamp: timestamp)
        if let chat = lastchat {
            chat.lastMessage = message
            chat.lastMessageTime = timestamp
            chatList.insert(chat, atIndex: 0)
        } else {
            lastchat = VIChat(owner: receiver.account, buddy: sender)
            chatList.insert(lastchat!, atIndex: 0)
            if let delegate = chatDelegate {
                delegate.chatWillStart(lastchat!)
            }
        }
        if let delegate = chatDelegate {
            delegate.chatDidReceiveMessage(lastchat!)
        }
    }
    
    @objc public func clientDidSendMessage(sender: SWClient!, to receiver: SWAccount!, message: String!, timestamp: NSDate!) {
        let chat = updateChatList(sender, buddy: receiver, message: message, timestamp: timestamp)
        if chat == nil {
            NSLog("WARN: Send message from not exist chat")
        } else if let delegate = chatDelegate {
            chatList.insert(chat!, atIndex: 0)
            delegate.chatDidSendMessage(chat!)
        }
    }
    
    /// Update relevent chat, and remove it from chatList, return for using.
    private func updateChatList(owner: SWClient, buddy: SWAccount, message: String, timestamp: NSDate) -> VIChat? {
        var lastChat: VIChat? = nil
        for i in 0 ..< chatList.count {
            if chatList[i].owner.getFullAccountString() == buddy.getFullAccountString() {
                lastChat = chatList[i]
                chatList.removeAtIndex(i)
            }
        }
        return lastChat
    }
    
//    private func sortChatList() {
//        chatList.sortInPlace { (left, right) -> Bool in
//            if left.lastMessageTime != nil && right.lastMessageTime != nil {
//                return left.lastMessageTime!.compare(right.lastMessageTime!) == .OrderedAscending
//            }
//            return false
//        }
//    }
}
