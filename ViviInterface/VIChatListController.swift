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
    
    var chatList: [VIChat] = []
    public var selectedChatIndex: Int = -1 {
        didSet {
            if selectedChatIndex >= 0 && selectedChatIndex < chatList.count {
                chatDelegate?.chatIsSelected(chatList[selectedChatIndex])
            }
        }
    }
    @objc public var owner: SWAccount!
    
    public var chatCount: Int {
        get {
            return chatList.count
        }
    }
    
    init(owner: SWAccount) {
        self.owner = owner
    }
    
    /// Called when client did receive a message from an account.
    /// This will add a new chat when the chat has not been established.
    /// Or update chat and put it to the index 0 of chat list.
    @objc public func clientDidReceivedMessageFrom( sender: SWAccount!, message: String!, timestamp: NSDate!) {
        let lastchat = updateChatList(withBuddy: sender, message: message, timestamp: timestamp)
        if let delegate = chatDelegate {
            delegate.chatDidReceiveMessage(lastchat)
        }
    }
    
    @objc public func clientWillSendMessageTo(receiver: SWAccount!, message: String!, timestamp date: NSDate!) {
        // FIXME: should I add not sended message to chat list?
        let lastchat = updateChatList(withBuddy: receiver, message: message, timestamp: date)
        if let delegate = chatDelegate {
            delegate.chatWillSendMessage(lastchat)
        }
    }
    
    /// Called when client did send a message to an account.
    /// This will add a new chat when the chat has not been established.
    /// Or update chat and put it to the index 0 of chat list.
    @objc public func clientDidSendMessageTo(receiver: SWAccount!, message: String!, timestamp: NSDate!) {
        let lastchat = updateChatList(withBuddy: receiver, message: message, timestamp: timestamp)
        if let delegate = chatDelegate {
            delegate.chatDidSendMessage(lastchat)
        }
    }
    
    /// Update relevent chat with new message.
    /// If no chat is relevent to buddy, new chat will be created.
    /// Updated or new created chat will be placed at index 0 of chat list.
    func updateChatList(withBuddy buddy: SWAccount, message: String, timestamp: NSDate) -> VIChat {
        var lastchat: VIChat? = nil
        for i in 0 ..< chatList.count {
            if chatList[i].buddy.getFullAccountString() == buddy.getFullAccountString() {
                lastchat = chatList[i]
                chatList.removeAtIndex(i)
                break
            }
        }
        if let chat = lastchat {
            chatList.insert(chat, atIndex: 0)
        } else {
            lastchat = VIChat(owner: owner, buddy: buddy)
            chatList.insert(lastchat!, atIndex: 0)
            if let delegate = chatDelegate {
                delegate.chatWillStart(lastchat!)
            }
        }
        lastchat!.lastMessage = message
        lastchat!.lastMessageTime = timestamp
        return lastchat!
    }
    
    public func getChatWithBuddy(buddy: SWAccount) -> VIChat? {
        var chat: VIChat? = nil
        for i in 0 ..< chatList.count {
            if chatList[i].buddy.getFullAccountString() == buddy.getFullAccountString() {
                chat = chatList[i]
                break
            }
        }
        return chat
    }
    
    public func addChatWithBuddy(buddy: SWAccount) -> VIChat {
        if let existedChat = getChatWithBuddy(buddy) {
            return existedChat
        } else {
            let newChat = VIChat(owner: owner, buddy: buddy)
            chatList.insert(newChat, atIndex: 0)
            if let delegate = chatDelegate {
                delegate.chatWillStart(newChat)
            }
            return newChat
        }
    }
    
    public func chatAtIndex(index: Int) -> VIChat? {
        if index >= 0 && index < chatList.count {
            return chatList[index]
        } else {
            return nil
        }
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
