//
//  PreferenceViewController.swift
//  Vivi
//
//  Created by Junyuan Hong on 8/7/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Cocoa
import ViviInterface
import ViviSwiften

class PreferenceViewController: NSViewController {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let clientMgr = VIClientManager.sharedClientManager

    @IBOutlet weak var accountTextField: NSTextField!
    @IBOutlet weak var passwordTextField: NSSecureTextField!
    @IBOutlet weak var domainTextField: NSTextField!
    @IBOutlet weak var portTextField: NSTextField!
    @IBOutlet weak var enableButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        accountTextField.stringValue = defaults.objectForKey("account") as! String
        passwordTextField.stringValue = defaults.objectForKey("password") as! String
        domainTextField.stringValue = defaults.objectForKey("hostname") as! String
        portTextField.stringValue = String(defaults.objectForKey("port") as! Int)
        enableButton.state = defaults.objectForKey("enabled") as! Int
    }
    
    @IBAction func accountEdited(sender: NSTextField) {
        defaults.setObject(sender.stringValue, forKey: "account")
    }
    
    @IBAction func passwordEdited(sender: NSSecureTextField) {
        defaults.setObject(sender.stringValue, forKey: "password")
    }
    
    @IBAction func domainEdited(sender: NSTextField) {
        defaults.setObject(sender.stringValue, forKey: "hostname")
    }
    
    @IBAction func portEdited(sender: NSTextField) {
        defaults.setObject(Int(sender.stringValue), forKey: "port")
    }
    
    @IBAction func enableChecked(sender: NSButton) {
        defaults.setObject(enableButton.state, forKey: "enabled")
        if sender.state == NSOnState {
            clientMgr.loadFromDefaults(defaults)
            enableButton.state = defaults.objectForKey("enabled") as! Int
            if enableButton.state == NSOnState {
                accountTextField.enabled = false;
                passwordTextField.enabled = false;
                domainTextField.enabled = false;
                portTextField.enabled = false;
            }
        } else if sender.state == NSOffState {
            clientMgr.removeClient(clientMgr.getClient(withAccountName: accountTextField.stringValue))
        }
    }
}
