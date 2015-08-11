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
    
    @IBOutlet var clientArrayController: NSArrayController!
    
    weak var managedObjectContext: NSManagedObjectContext! = {
        return (NSApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func enableChecked(sender: NSButton) {
        if sender.state == NSOnState {
            let entity = clientArrayController.selectedObjects[0] as! VIClientMO
            clientMgr.loadFromEnity(entity)
            enableButton.state = (entity.enabled?.integerValue)!
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
