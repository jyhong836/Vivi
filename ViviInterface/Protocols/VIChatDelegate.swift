//
//  VIChatDelegate.swift
//  Vivi
//
//  Created by Junyuan Hong on 7/31/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import ViviSwiften

public protocol VIChatDelegate {
    /// New message is stored in chat.lastMessage.
    func chatDidReceiveMessage(chat: VIChat)
    
    /// New message is stored in chat.lastMessage.
    func chatDidSendMessage(chat: VIChat, updatedIndex index: Int)
    /// New message is stored in chat.lastMessage, but not sended.
    func chatFailSendMessage(chat: VIChat, updatedIndex index: Int, error: VSClientErrorType)
    
    func chatWillSendMessage(chat: VIChat, updatedIndex index: Int)
    
    /// New chat will start. This creats chat, but will not include any message or timestamp.
//    func chatWillStart(chat: VIChat)
    
    func chatIsSelected(chat: VIChat)
}
