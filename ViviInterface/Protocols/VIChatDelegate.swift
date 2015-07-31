//
//  VIChatDelegate.swift
//  Vivi
//
//  Created by Junyuan Hong on 7/31/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

public protocol VIChatDelegate {
    /// New message is stored in chat.lastMessage.
    func chatDidReceiveMessage(chat: VIChat)
    
    /// New message is stored in chat.lastMessage
    func chatDidSendMessage(chat: VIChat)
    
    /// New chat will start. This just created chat will not include any message or timestamp.
    func chatWillStart(chat: VIChat)
}
