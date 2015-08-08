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
public let VIChatListChatDidAddNotification = "VIChatListChatDidAddNotification"
public let VIChatListChatWillSendNotification = "VIChatListChatWillSendNotification"
public let VIChatListChatDidSendNotification = "VIChatListChatDidSendNotification"
public let VIChatListChatDidReceiveNotification = "VIChatListChatDidReceiveNotification"

/// VIChatListController is binded to one SWClient
public class VIChatListController: VSChatListControllerProtocol {
    
    public var chatDelegate: VIChatDelegate?
    let notificationCenter = NSNotificationCenter.defaultCenter()
    
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
    
    // MARK: Delegate for client actions
    
    /// Called when client did receive a message from an account.
    /// This will add a new chat when the chat has not been established.
    /// Or update chat and put it to the index 0 of chat list.
    @objc public func clientDidReceivedMessageFrom(sender: SWAccount!, message: String!, timestamp: NSDate!) {
        let (lastchat, oldIndex) = updateChatList(withBuddy: sender)
        lastchat.addMessage(message, timestamp: timestamp, direction: .From)
        if let delegate = chatDelegate {
            delegate.chatDidReceiveMessage(lastchat)
        }
        notificationCenter.postNotificationName(VIChatListChatDidReceiveNotification, object: self, userInfo: ["oldIndex": oldIndex])
    }
    
    @objc public func clientWillSendMessageTo(receiver: SWAccount!, message: String!, timestamp date: NSDate!) {
        // FIXME: should I add not sended message to chat list?
        let (lastchat, oldIndex) = updateChatList(withBuddy: receiver)
        lastchat.addMessage(message, timestamp: date, direction: .WillTo)
//        let updatedIndex = lastchat.updateMessage(message, timestamp: date, direction: .WillTo)
        if let delegate = chatDelegate {
//            delegate.chatWillSendMessage(lastchat, updatedIndex: updatedIndex) // TODO: pass index
            delegate.chatWillSendMessage(lastchat, updatedIndex: -1) // TODO: pass index
        }
        notificationCenter.postNotificationName(VIChatListChatWillSendNotification, object: self, userInfo: ["oldIndex": oldIndex])
    }
    
    /// Called when client did send a message to an account.
    /// This will add a new chat when the chat has not been established.
    /// Or update chat and put it to the index 0 of chat list.
    @objc public func clientDidSendMessageTo(receiver: SWAccount!, message: String!, timestamp: NSDate!) {
        let lastchat = getChatWithBuddy(receiver)!
        let updatedIndex = lastchat.updateMessage(message, timestamp: timestamp, direction: .To)
        if let delegate = chatDelegate {
            delegate.chatDidSendMessage(lastchat, updatedIndex: updatedIndex)
        }
        notificationCenter.postNotificationName(VIChatListChatDidSendNotification, object: self, userInfo: ["chatIndex": Int(chatList.indexOf(lastchat)!), "messageIndex": updatedIndex])
    }
    
    @objc public func clientFailSendMessageTo(receiver: SWAccount!, message: String!, timestamp date: NSDate!, error: VSClientErrorType) {
        // TODO: Add process for not sended message
        let lastchat = getChatWithBuddy(receiver)!
        let updatedIndex = lastchat.updateMessage(message, timestamp: date, direction: .To)
        if let delegate = chatDelegate {
            delegate.chatFailSendMessage(lastchat, updatedIndex: updatedIndex, error: error)
        }
        notificationCenter.postNotificationName(VIChatListChatDidSendNotification, object: self, userInfo: ["chatIndex": Int(chatList.indexOf(lastchat)!), "messageIndex": updatedIndex, "error": error.rawValue])
    }
    
    /// Update relevent chat with new message.
    /// If no chat is relevent to buddy, new chat will be created.
    /// Updated or new created chat will be placed at index 0 of chat list.
    ///
    /// - Returns: (lastChat, oldIndex), oldIndex is the old index of updated chat.
    /// return -1, if no old index, but the chat has been inserted at index 0. Do 
    /// not insert new chat at index 0 when oldIndx is -1.
    func updateChatList(withBuddy buddy: SWAccount) -> (VIChat, oldIndex: Int) {
        // Try to add chat
        let (lastChat, isNew) = addChatWithBuddy(buddy)
        var index = 0
        if !isNew {
            index = chatList.indexOf(lastChat)!
            chatList.removeAtIndex(index)
            chatList.insert(lastChat, atIndex: 0)
        } else {
            index = -1
        }
        return (lastChat, index)
    }
    
    // MARK: API for aceess and set element
    
    public func getChatWithBuddy(buddy: SWAccount) -> VIChat? {
        var chat: VIChat? = nil
        for i in 0 ..< chatList.count {
            if chatList[i].buddy.getAccountString() == buddy.getAccountString() {
                chat = chatList[i]
                break
            }
        }
        return chat
    }
    
    public func addChatWithBuddy(buddy: SWAccount) -> (VIChat, isNew: Bool) {
        if let existedChat = getChatWithBuddy(buddy) {
            return (existedChat, false)
        } else {
            let newChat = VIChat(owner: owner, buddy: buddy)
            chatList.insert(newChat, atIndex: 0)
            notificationCenter.postNotificationName(
                VIChatListChatDidAddNotification, object: self, userInfo: ["index": 0])
            return (newChat, true)
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
