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
    
    let imageViewSpacing = CGFloat(10.0)
    var delegate: MessageTableCellViewDelegate?
    var cellRow: Int = -1
    var cellHeight: CGFloat = 60.0 {
        didSet {
            if cellHeight != oldValue {
                delegate?.cellDidChangeHeight(cellRow, height: cellHeight)
            }
        }
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
        cellHeight = bubleImageView.frame.height + imageViewSpacing
    }
}
