//
//  AddAccountViewController.swift
//  Vivi
//
//  Created by Junyuan Hong on 8/12/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Cocoa
import ViviSwiften
import ViviInterface

protocol AddAccountViewControllerDelegate {
    func addAccount(account: SWAccount, password: String)
}

class AddAccountViewController: NSViewController {
    
    var delegate: AddAccountViewControllerDelegate?
    
    var account: String?
    var password: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    func showAlert(text: String) {
        let alert = NSAlert()
        alert.addButtonWithTitle("OK")
        alert.messageText = text
        alert.runModal()
    }
    
    @IBAction func btnAddClicked(sender: AnyObject) {
        guard account != nil else {
            showAlert("Account should not be empty")
            return
        }
        guard password != nil else {
            showAlert("Password should not be empty")
            return
        }
        do {
            if let swaccount = try VIClientManager.sharedClientManager.canAddClientEnity(withAccountName: account!, andPasswd: password!) {
                delegate?.addAccount(swaccount, password: password!)
                self.dismissViewController(self)
            } else {
                showAlert("Account has existed")
            }
        } catch {
            showAlert("Fail to add client: \(error)")
        }
    }
}
