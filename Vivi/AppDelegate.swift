//
//  AppDelegate.swift
//  Vivi
//
//  Created by Junyuan Hong on 7/21/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Cocoa
import ViviSwiften

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, VSVivi {


    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        setSharedVivi(self)
        
        clientController = ClientController()
        clientController?.controllerDidLoad()
//        clientController?.client.connect()
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
        clientController?.controllerWillClose()
    }
    
    // MARK: VSVivi implementation
    
    var clientController: VSClientManager?
    var isQuitting: Bool = false

}

