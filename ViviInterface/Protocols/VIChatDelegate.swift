//
//  VIChatDelegate.swift
//  Vivi
//
//  Created by Junyuan Hong on 7/31/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

public protocol VIChatDelegate {
    func chatDidReceiveMessage(chat: VIChat)
    func chatDidSendMessage(chat: VIChat)
    func chatWillStart(chat: VIChat)
}
