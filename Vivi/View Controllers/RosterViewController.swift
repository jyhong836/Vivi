//
//  RosterViewController.swift
//  Vivi
//
//  Created by Junyuan Hong on 8/17/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Cocoa
import ViviInterface

class RosterViewController: NSViewController {
    
    weak var managedObjectContext: NSManagedObjectContext! = {
        return VICoreDataController.shared.managedObjectContext
        }()

    @IBOutlet weak var collectionView: NSCollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        collectionView.itemPrototype = self.storyboard?.instantiateControllerWithIdentifier("RosterCollectionItem") as? NSCollectionViewItem
    }
    
    let nodeSortDescripoter = NSSortDescriptor(key: "node", ascending: true, selector: Selector("compare:"))
    let domainSortDescripoter = NSSortDescriptor(key: "domain", ascending: true, selector: Selector("compare:"))
    var sortDescriptors: [NSSortDescriptor] {
        get {
            return [nodeSortDescripoter, domainSortDescripoter]
        }
    }
    
}
