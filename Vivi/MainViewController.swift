//
//  ViewController.swift
//  Vivi
//
//  Created by Junyuan Hong on 7/21/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Cocoa
import ViviSwiften
import ViviInterface

class MainViewController: NSViewController, VSClientDelegate, VSXMPPRosterDelegate, VIChatDelegate, VIClientManagerDelegate, NSUserNotificationCenterDelegate {

    @IBOutlet weak var sesConView: NSView!
    @IBOutlet weak var sessionView: NSView!
    @IBOutlet weak var chatView: NSView!
    
    weak var sessionViewController: SessionViewController?
    weak var chatViewController: ChatViewController?
    
    let clientMgr = VIClientManager.sharedClientManager
    var clients: [SWClient] = []
    var currentClient: SWClient? = nil {
        didSet {
            sessionViewController?.currentClient = currentClient
        }
    }
    
    let notification = NSUserNotification()
    
    let notificationCenter = NSNotificationCenter.defaultCenter()
    var chatDidReceiveObserver: NSObjectProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        clientMgr.delegate = self
        
        let mainQueue = NSOperationQueue.mainQueue()
        chatDidReceiveObserver = notificationCenter.addObserverForName(VIClientChatDidReceiveMsgNotification, object: nil, queue: mainQueue, usingBlock: {(n)->Void in
            let clientMO = self.currentClient?.managedObject as! VIClientMO
            self.deliverNewMessageNotification(clientMO.chatAtIndex(0)!)
        })
        initUserNotification()
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "SessionViewSegue":
                sessionViewController = segue.destinationController as? SessionViewController
                sessionViewController?.currentClient = currentClient
            case "ChatViewSegue":
                chatViewController = segue.destinationController as? ChatViewController
                chatViewController?.currentClient = currentClient
            default: break
            }
        }
    }
    
    // MARK: Implementations for VSClientDelegate
    
    func clientDidConnect(client: SWClient!) {
        NSLog("client(\(client.account.getAccountString())) did connect")
    }
    
    func clientDidDisconnect(client: SWClient!, errorCode code: Int32) {
        NSLog("client(\(client.account.getAccountString())) did disconnect, with errorcodr(\(code))")
    }
    
    func clientDidReceivePresence(client: SWClient!, fromAccount account: SWAccount!, currentPresence presenceType: Int32, currentShow show: Int32, currentStatus status: String!) {
        NSLog("client(\(client.account.getAccountString())) did receive presence from \(account.getAccountString())")
    }
    
    func clientDidReceiveMessage(client: SWClient!, fromAccount account: SWAccount!, inContent content: String!) {
        NSLog("client(\(client.account.getAccountString())) did receive message from \(account.getAccountString()): \(content)")
    }
    
    // MARK: Implementations for VSXMPPRosterDelegate
    
    func rosterDidInitialize() {
        currentClient?.roster.printItems()
    }
    
    // MARK: Implementations for VIChatDelegate
    
    func chatIsSelected(chat: VIChatMO) {
        chatViewController?.currentChat = chat
        chatViewController?.view.hidden = false
    }
    
    // MARK: Implement VIClientManagerDelegate
    func managerDidAddClient(client: SWClient?) {
        // FIXME: The new client should not be the currentClient in multi-client situation.
        if let c = client {
            clients.append(c)
            currentClient = c
            
            c.delegate = self
            c.roster.delegate = self
            (c.managedObject as! VIClientMO).chatDelegate = self
            if let infoDict = NSBundle.mainBundle().localizedInfoDictionary {
                let appName = infoDict[String(kCFBundleNameKey)] as! String
                let appVer = infoDict[String(kCFBundleVersionKey)] as! String
                c.setSoftwareName(appName, currentVersion: appVer)
            }
            
            // TODO: remove test code
//            (c.managedObject as! VIClientMO).addChatWithBuddy(SWAccount(accountName: "test@noface"))
            (c.managedObject as! VIClientMO).addChatWithBuddy(SWAccount(accountName: "test1@noface"))
            
            sessionViewController?.currentClient = c
            chatViewController?.currentClient = c
        }
    }
    
    func managerDidRemoveClient(client: SWClient?) {
        // TODO: test remove client, and remove from subview controllers.
        if client != nil && currentClient == client {
            currentClient = nil
            sessionViewController?.currentClient = nil
            chatViewController?.currentClient = nil
        }
    }
    
    // MARK: User notification
    /// Deliver new message user notification in screen.
    private func deliverNewMessageNotification(chat: VIChatMO) {
        notification.title = chat.buddy!.accountString
        notification.informativeText = chat.lastMessage
        notification.userInfo = ["account": chat.buddy!.accountString]
        NSUserNotificationCenter.defaultUserNotificationCenter().deliverNotification(notification)
    }
    
    func initUserNotification() {
        // init user notification
        NSUserNotificationCenter.defaultUserNotificationCenter().delegate = self
        notification.title = "Account"
        notification.informativeText = "message context"
        notification.soundName = NSUserNotificationDefaultSoundName
        notification.hasReplyButton = true
        //        notification.otherButtonTitle = "Ignore"
    }
    
    // MARK: Implement NSUserNotificationCenterDelegate
    func userNotificationCenter(center: NSUserNotificationCenter, shouldPresentNotification notification: NSUserNotification) -> Bool {
        return true
    }
    
    func userNotificationCenter(center: NSUserNotificationCenter, didActivateNotification notification: NSUserNotification) {
        if notification.activationType == .Replied {
            let userinfo = notification.userInfo!
            currentClient?.sendMessageToAccount(SWAccount(accountName: userinfo["account"] as! String),
                message: notification.response?.string)
        }
    }
}

