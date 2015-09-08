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

class MainViewController: NSViewController, VSClientDelegate, SessionViewControllerDelegate, VIClientManagerDelegate, NSUserNotificationCenterDelegate {

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
            if viewLoaded {
                updateButtonStates()
                if currentClient != nil {
                    accountLabel.stringValue = (currentClient!.account.accountString)!
                    let clientMO = currentClient!.managedObject as! VIClientMO
                    invisibleItem.hidden = !(clientMO.canbeinvisible!.boolValue)
                    
                    let accountMO = VIAccountMO.getAccount(currentClient!.account.nodeString, domain: currentClient!.account.domainString, managedObjectContext: VICoreDataController.shared.managedObjectContext)
                    if let imgData = accountMO?.avatar {
                        avaterView.image = NSImage(data: imgData)
                    }
                } else {
                    accountLabel.stringValue = "account"
                    invisibleItem.hidden = true
                    avaterView.image = nil
                    presencePopUpButton.selectItem(presencePopUpButton.itemWithTitle("Offline"))
                }
            }
        }
    }
    
    let notification = NSUserNotification()
    
    let notificationCenter = NSNotificationCenter.defaultCenter()
    var chatDidReceiveObserver: NSObjectProtocol?
    
    // MARK: - View controllers

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
        
        updateButtonStates()
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
                sessionViewController?.delegate = self
            case "ChatViewSegue":
                chatViewController = segue.destinationController as? ChatViewController
                chatViewController?.currentClient = currentClient
            default: break
            }
        }
    }
    
    // MARK: - Implementations for VSClientDelegate
    
    func clientDidConnect(client: SWClient!) {
        NSLog("client(\(client.account.accountString)) did connect")
    }
    
    func clientDidDisconnect(client: SWClient!, errorCode code: Int32) {
        NSLog("client(\(client.account.accountString)) did disconnect: (\(SWClientErrorType(rawValue: code)))")
    }
    
    func clientDidReceiveMessage(client: SWClient!, fromAccount account: SWAccount!, inContent content: String!) {
        NSLog("client(\(client.account.accountString)) did receive message from \(account.accountString): \(content)")
    }
    
    // MARK: - Implementations for VIChatDelegate
    
    func chatIsSelected(chat: VIChatMO) {
        chatViewController?.currentChat = chat
        chatViewController?.view.hidden = false
    }
    
    // MARK: - Implement VIClientManagerDelegate
    
    func managerDidAddClient(client: SWClient?) {
        // FIXME: The new client should not be the currentClient in multi-client situation.
        if let c = client {
            clients.append(c)
            currentClient = c
            
            c.delegate = self
            
            if let infoDict = NSBundle.mainBundle().infoDictionary {
                let appName = infoDict[String(kCFBundleNameKey)] as! String
                let appVer = infoDict[String("CFBundleShortVersionString")] as! String
                c.setSoftwareName(appName, currentVersion: appVer)
                // TODO: uncomment this line to setup discoInfo.
//                c.setDiscoInfo(appName, capsNode: "http://jyhong836.github.io/Vivi/", features: ["urn:xmpp:jingle:1"])
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
                context: (notification.response?.string)!)
        }
    }
    
    // MARK: Buttons
    
    @IBOutlet weak var accountLabel: NSTextField!
    @IBOutlet weak var avaterView: AvatarView!
    @IBOutlet weak var rosterButton: NSButton!
    @IBOutlet weak var presencePopUpButton: NSPopUpButton!
    
    private func updateButtonStates() {
        if currentClient != nil {
            avaterView.enabled = true
            rosterButton.enabled = true
            presencePopUpButton.enabled = true
        } else {
            avaterView.enabled = false
            rosterButton.enabled = false
            presencePopUpButton.enabled = false
        }
    }
    
    @IBOutlet weak var connectSpinner: NSProgressIndicator!
    
    var rosterViewCollapse: (()->Void)?
    
    @IBAction func rosterButtonClicked(sender: NSButton) {
        rosterViewCollapse?()
    }
    
    /// Require currentClient not be nil
    func sendPresence(presence: String) {
        currentClient!.invisible = presence == "Invisible"
        let (pres, show, status) = SWPresenceType.parseFrom(presence)
        NSLog("send presence(\(presence)): \(pres), \(show), \(status)")
        currentClient!.sendPresence(pres.rawValue, showType: show.rawValue, status: status)
    }
    
    @IBOutlet weak var invisibleItem: NSMenuItem!
    
    @IBAction func changePresenceBtnClicked(sender: NSPopUpButton) {
        let title = sender.selectedItem?.title
        guard title != nil else {
            fatalError("presence title is nil")
        }
        if title == "Offline" {
            // Try to disconnect client to server
            if let c = currentClient {
                if !c.isActive {
                    return
                }
                
                connectSpinner.hidden = false
                connectSpinner.startAnimation(sender)
                c.disconnectWithHandler({ (errcode) -> Void in
                    self.connectSpinner.hidden = true
                    self.connectSpinner.stopAnimation(sender)
                    if let err = SWClientErrorType(rawValue: errcode) {
                        let alert = NSAlert()
                        alert.addButtonWithTitle("OK")
                        alert.messageText = "Error: \(err)"
                        alert.runModal()
                    }
                })
            } else {
                fatalError("Attempt to disconnect from nil client.")
            }
        } else {
            // Try to connect client to server
            if let c = currentClient {
                if c.isAvailable {
                    sendPresence(title!)
                    return
                }
                // FIXME: If do not disconnect before reconnect, may cause some error.
//                else if c.isActive() {
//                    return
//                }
                
                let image = sender.selectedItem?.image
                sender.selectedItem?.image = nil
                connectSpinner.hidden = false
                connectSpinner.startAnimation(sender)
                
                c.connectWithHandler({ (errcode) -> Void in
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        sender.selectedItem?.image = image
                        self.connectSpinner.hidden = true
                        self.connectSpinner.stopAnimation(sender)
                        if let err = SWClientErrorType(rawValue: errcode) {
                            let alert = NSAlert()
                            alert.addButtonWithTitle("OK")
                            alert.messageText = "Error: \(err)"
                            alert.runModal()
                            sender.selectItemWithTitle("Offline")
                        }
                    })
                    if SWClientErrorType(rawValue: errcode) == nil {
                        self.sendPresence(title!)
                    }
                    if !c.hasInitializedServerCaps {
                        c.updateServerCapsWithHandler({ (errString) -> Void in
                            if let err = errString {
                                NSLog("Error when update server caps: \(err)")
                            } else {
                                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                    self.invisibleItem.hidden = !c.canBeInvisible
                                    (c.managedObject as! VIClientMO).canbeinvisible = NSNumber(bool: c.canBeInvisible)
                                })
                            }
                        })
                    }
                })
            } else {
                fatalError("Attempt to connect to nil client.")
            }
        }
    }
}

