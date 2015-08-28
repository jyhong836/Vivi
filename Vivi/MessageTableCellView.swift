//
//  MessageTableCellView.swift
//  Vivi
//
//  Created by Junyuan Hong on 8/2/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Cocoa

class MessageTableCellView: NSTableCellView {

    @IBOutlet weak var bubleImageView: NSImageView!
    @IBOutlet weak var warningBadge: NSImageView!
    @IBOutlet weak var sendingSpinner: NSProgressIndicator!
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }
    
    var showFailBadge: Bool = false {
        didSet {
            if oldValue != showFailBadge {
                if let badge = warningBadge {
                    badge.hidden = !showFailBadge
                }
            }
        }
    }
    
    var showSendingBadge: Bool = false {
        didSet {
            if oldValue != showFailBadge {
                if let spinner = sendingSpinner {
                    spinner.hidden = !showFailBadge
                    if showFailBadge {
                        spinner.startAnimation(self)
                    } else {
                        spinner.stopAnimation(self)
                    }
                }
            }
        }
    }
    
    func clearBadges() {
        showSendingBadge = false
        showFailBadge = false
    }
    
}
