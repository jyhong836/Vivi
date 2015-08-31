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

    @IBOutlet weak var descriptionTextField: NSTextField!
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
    }
    
    @IBAction func enableChecked(sender: NSButton) {
        if sender.state == NSOnState {
            let clientMO = clientArrayController.selectedObjects[0] as! VIClientMO
            clientMgr.loadFromEnity(clientMO)
            clientMgr.addUnreadCountObserver(NSApp.delegate as! AppDelegate, forClient: clientMO)
            enableButton.state = (clientMO.enabled?.integerValue)!
        } else if sender.state == NSOffState {
            clientMgr.removeClient(clientMgr.getClient(withAccountName: accountTextField.stringValue))
        }
    }
    
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addAccountSegue" {
            let vc = segue.destinationController as! AddAccountViewController
            vc.delegate = self
        }
    }
    
    func addAccount(account: SWAccount, password: String) {
//        clientArrayController.add(self)
        let moc = clientMgr.managedObjectContext!
        let client = NSEntityDescription.insertNewObjectForEntityForName("Client", inManagedObjectContext: moc) as! VIClientMO
        client.accountname = account.accountString
        client.password = password
        client.hostname = account.domainString
        client.accdescription = account.domainString
        clientArrayController.addObject(client)
    }
    
    @IBAction func accountTextChanged(sender: NSTextField) {
        let clientMO = clientArrayController.selectedObjects.last as! VIClientMO
        if clientMO.accdescription == nil {
            clientMO.accdescription = SWAccount(accountName: sender.stringValue).domainString
        }
    }
}
