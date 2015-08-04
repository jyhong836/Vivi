//
//  ChatMessageViewController.swift
//  Vivi
//
//  Created by Junyuan Hong on 8/2/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Cocoa
import ViviInterface

class ChatMessageViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource, MessageTableCellViewDelegate {

    @IBOutlet weak var messageTableView: NSTableView!
    
    var currentChat: VIChat? {
        didSet {
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.messageTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    // MARK: API for update chat table view
    /// Call when chat did update message at index. This will only reload one message cell view.
    func chatDidUpdateMessageAtIndex(index: Int) {
        if currentChat != nil {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.messageTableView.reloadDataForRowIndexes(NSIndexSet(index: index), columnIndexes: NSIndexSet(index: 0))
            })
        } else {
            assert(false, "Tend to update an chat when currentChat is not set up")
        }
    }
    
    /// Call when chat add one message, this will update chat table view.
    func chatDidAddMessage() {
        if currentChat != nil {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.messageTableView.insertRowsAtIndexes(NSIndexSet(index: self.messageTableView.numberOfRows), withAnimation: NSTableViewAnimationOptions.SlideUp)
                if self.messageTableView.numberOfRows == 1 {
                    // WARN: Do not remove this. Here is to reload data for avoiding the draw error occur when too heigh cell view is loaded
                    self.messageTableView.reloadData()
                }
            })
        } else {
            assert(false, "Tend to update an chat when currentChat is not set up")
        }
    }
    
    // MARK: Implementations for NSTableViewDataSource
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        if let chat = currentChat {
            return chat.messageCount
        } else {
            return 0
        }
    }
    
    // MARK: Implementations for NSTableViewDelegate
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var cell: MessageTableCellView?
        if let dir = currentChat?.messageAtIndex(row)!.direction {
            switch dir {
            case .From:
                cell = tableView.makeViewWithIdentifier("InMessageCellView", owner: self) as? MessageTableCellView
            case .To:
                cell = tableView.makeViewWithIdentifier("OutMessageCellView", owner: self) as? MessageTableCellView
            case .WillTo: // TODO: add "will to" processing
                cell = tableView.makeViewWithIdentifier("OutMessageCellView", owner: self) as? MessageTableCellView
            case .FailTo: // TODO: add "fail to" processing
                cell = tableView.makeViewWithIdentifier("OutMessageCellView", owner: self) as? MessageTableCellView
            default:
                break
            }
        }
        if let cl = cell {
            cl.textField?.stringValue = (currentChat?.messageAtIndex(row)?.content)!
            cl.cellRow = row
            cl.delegate = self
        }
        return cell
    }
    
    func tableView(tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        return true
    }
    
    func tableView(tableView: NSTableView, didAddRowView rowView: NSTableRowView, forRow row: Int) {
        cellHeightList.insert(60, atIndex: row)
    }
    
    func tableView(tableView: NSTableView, didRemoveRowView rowView: NSTableRowView, forRow row: Int) {
        cellHeightList.removeAtIndex(row)
    }
    
    let minTableViewRowHeight = 60
    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        if row >= 0 && row < cellHeightList.count {
            return cellHeightList[row]
        } else {
            return CGFloat(minTableViewRowHeight)
        }
    }
    
    // MARK: Implementation for MessageTableCellViewDelegate
    var cellHeightList: [CGFloat] = []
    func cellDidChangeHeight(row: Int, height: CGFloat) {
        cellHeightList[row] = height
        messageTableView.noteHeightOfRowsWithIndexesChanged(NSIndexSet(index: row))
    }
}
