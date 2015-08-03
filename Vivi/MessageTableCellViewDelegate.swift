//
//  MessageTableCellViewDelegate.swift
//  Vivi
//
//  Created by Junyuan Hong on 8/3/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Foundation

protocol MessageTableCellViewDelegate {
    func cellDidChangeHeight(row: Int, height: CGFloat)
}
