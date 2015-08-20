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
import CoreData

class PreferenceViewController: NSViewController, AddAccountViewControllerDelegate {
    
//    let defaults = NSUserDefaults.standardUserDefaults()
    let clientMgr = VIClientManager.sharedClientManager

    @IBOutlet weak var accountTextField: NSTextField!
    @IBOutlet weak var passwordTextField: NSSecureTextField!
    @IBOutlet weak var domainTextField: NSTextField!
    @IBOutlet weak var portTextField: NSTextField!
    @IBOutlet weak var enableButton: NSButton!
    
    @IBOutlet var clientArrayController: NSArrayController!
    
    weak var managedObjectContext: NSManagedObjectContext! = {
        return VICoreDataController.shared.managedObjectContext
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func viewDidAppear() {
        // FIXME: the client has not been selected?
//        let entity = clientArrayController.selectedObjects[0] as! VIClientMO
//        enableButton.state = (entity.enabled?.integerValue)!
//        if enableButton.state == NSOnState {
//            enableTextFields(false)
//        }
    }
    
    @IBAction func enableChecked(sender: NSButton) {
        if sender.state == NSOnState {
            let entity = clientArrayController.selectedObjects[0] as! VIClientMO
            clientMgr.loadFromEnity(entity)
            enableButton.state = (entity.enabled?.integerValue)!
//            if enableButton.state == NSOnState {
//                enableTextFields(false)
//            }
        } else if sender.state == NSOffState {
            clientMgr.removeClient(clientMgr.getClient(withAccountName: accountTextField.stringValue))
//            enableTextFields(true)
        }
    }
    
//    func enableTextFields(enabled: Bool) {
//        accountTextField.enabled = enabled;
//        passwordTextField.enabled = enabled;
//        domainTextField.enabled = enabled;
//        portTextField.enabled = enabled;
//    }
    
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addAccountSegue" {
            let vc = segue.destinationController as! AddAccountViewController
            vc.delegate = self
        }
    }
    
    func shouldAddAccount(account: SWAccount, password: String) {
//        clientArrayController.add(self)
        let moc = clientMgr.managedObjectContext!
        let client = NSEntityDescription.insertNewObjectForEntityForName("Client", inManagedObjectContext: moc) as! VIClientMO
        client.accountname = account.getAccountString()
        client.password = password
        client.hostname = account.getDomainString()
        clientArrayController.addObject(client)
    }
}
