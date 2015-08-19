//
//  MainSplitViewController.swift
//  Vivi
//
//  Created by Junyuan Hong on 8/17/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Cocoa

class MainSplitViewController: NSSplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        let mainVC = splitViewItems[0].viewController as! MainViewController
        mainVC.rosterViewCollapse = {
            () -> Void in
            self.splitViewItems[1].animator().collapsed = !self.splitViewItems[1].collapsed
        }
        self.splitViewItems[1].collapsed = true
    }
    
}
