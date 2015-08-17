//
//  RosterViewController.swift
//  Vivi
//
//  Created by Junyuan Hong on 8/17/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Cocoa

class RosterViewController: NSViewController {

    @IBOutlet weak var collectionView: NSCollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        collectionView.itemPrototype = (self.storyboard?.instantiateControllerWithIdentifier("RosterCollectionItem") as! NSCollectionViewItem)
    }
    
}
