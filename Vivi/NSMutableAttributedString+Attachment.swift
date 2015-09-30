//
//  NSTextStorage+Attachment.swift
//  Vivi
//
//  Created by Junyuan Hong on 9/3/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Cocoa
import ViviInterface
import MMMarkdown

extension NSMutableAttributedString {
    
    // MARK: - Text attachment transform
    
    var attachmentIndexs: [Int] {
        get {
            var attachmentIndexs: [Int] = []
            
            let strRange = NSMakeRange(0, self.length)
            if strRange.length > 0 {
                var index = 0
                repeat {
                    var effectiveRange = NSRange()
                    let attributes = self.attributesAtIndex(index, longestEffectiveRange: &effectiveRange, inRange: strRange)
                    if attributes[NSAttachmentAttributeName] is NSTextAttachment {
                        attachmentIndexs.append(index)
                    }
                    index = effectiveRange.location + effectiveRange.length
                } while (index < strRange.length)
            }
            
            return attachmentIndexs
        }
    }
    
    /// Get attachment at index. Return nil if not found.
    func attachmentAtIndex(index: Int) -> NSTextAttachment? {
        let strRange = NSMakeRange(0, self.length)
        if strRange.length > 0 {
            let attributes = self.attributesAtIndex(index, longestEffectiveRange: nil, inRange: strRange)
            if let att = attributes[NSAttachmentAttributeName] as? NSTextAttachment {
                return att
            }
        }
        return nil
    }
    
    /// Transfer string stored with attachments. All attachments will be
    /// transfered to format like "[filepath]".
    func transferedStringWithAttachments() -> String {
        let transferedStorage = NSTextStorage(attributedString: self)
        let strRange = NSMakeRange(0, transferedStorage.length)
        if strRange.length > 0 {
            let attIdxs = attachmentIndexs;
            
            for idx in attIdxs.reverse() {
                if let att = attachmentAtIndex(idx) {
                    // TODO: Uncomment this, if error occures with attachment file wrapper.
//                    guard att.fileWrapper != nil else {
//                        fatalError("not found fileWrapper in attachment")
//                    }
//                    guard att.fileWrapper!.preferredFilename != nil else {
//                        fatalError("not found preferredFilename in attachment.fileWrapper")
//                    }
                    transferedStorage.replaceCharactersInRange(NSMakeRange(idx, 1), withAttributedString: NSAttributedString(string: "[\(att.fileWrapper!.preferredFilename!)]"))
                }
            }
        }
        
        return transferedStorage.string
    }
    
    /// Match parttern in **reverse** direction.
    func matchPattern(parttern: String, matched: (matchedRange: NSRange)->Void) {
        do {
            let regexp = try NSRegularExpression(pattern: parttern, options: NSRegularExpressionOptions(rawValue: 0))
            let contentRange = NSMakeRange(0, self.length)
            let matches = regexp.matchesInString(self.string, options: NSMatchingOptions(rawValue: 0), range: contentRange)
            
            for match in matches.reverse() { // reverse to avoid changing replace ranges.
                matched(matchedRange: match.range)
            }
        } catch {
            fatalError("Fail to create regular expression: \(error)")
        }
    }
    
    /// Create and initialize NSTextAttachment with managed object and file cell.
    func createAttachmentFromManagedObject(attachmentMO: VIAttachmentMO, filecellWithWrapper: (fileWrapper: NSFileWrapper)->TextAttachmentFileCell) -> NSTextAttachment {
        let attachment = NSTextAttachment()
        
        let fullFilename = attachmentMO.filename! // file path
        do {
            let fileWrapper = try NSFileWrapper(URL: NSURL(fileURLWithPath: fullFilename), options: NSFileWrapperReadingOptions.Immediate) // .Immediate will cause error when file not exists.
            
            // init file cell
            let filecell = filecellWithWrapper(fileWrapper: fileWrapper)
            
            filecell.attachmentMO = attachmentMO
            attachmentMO.fileTransfer?.delegate = filecell
            
            attachment.attachmentCell = filecell
            attachment.fileWrapper = fileWrapper
        } catch {
            fatalError("Fail to create file wrapper: \(error)")
        }
        
        return attachment
    }
    
    /// Transform string with file name parttern('[file name]') to NSAttributedString. The file
    /// name pattern is transformed to NSTextAttachment.
    convenience init(content: String, attachmentMOWithName: (filename: String)->VIAttachmentMO?, filecellWithWrapper: (fileWrapper: NSFileWrapper)->TextAttachmentFileCell) {
        self.init(string: content)
        
        matchPattern("\\[[^]]+\\]") { (matchedRange) -> Void in
            var bareRange = matchedRange
            bareRange.location += 1
            bareRange.length -= 2
            
            let filename = self.attributedSubstringFromRange(bareRange).string
            
            if let attachmentMO = attachmentMOWithName(filename: filename) {
                // found corresponding file name
                let attachment = self.createAttachmentFromManagedObject(attachmentMO, filecellWithWrapper: filecellWithWrapper)
                self.replaceCharactersInRange(matchedRange, withAttributedString: NSAttributedString(attachment: attachment))
            }
        }
    }
    
    // MARK: - Markdown and HTML transform
    
    /// Create attributed string from markdown string.
    convenience init(markdownString string: String) throws {
        let informationHTML = try MMMarkdown.HTMLStringWithMarkdown(string, extensions: MMMarkdownExtensions.GitHubFlavored)
        
        let informationData = informationHTML.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        try self.init(data: informationData!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
    }
    
    func htmlString() throws -> String? {
        let htmlData = try self.dataFromRange(NSMakeRange(0, self.length), documentAttributes: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType])
        return String(data: htmlData, encoding: NSUTF8StringEncoding)
    }
    
}
