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

    var attachments: [NSTextAttachment] {
        get {
            var attachments: [NSTextAttachment] = []
            
            let strRange = NSMakeRange(0, self.length)
            if strRange.length > 0 {
                var index = 0
                repeat {
                    var effectiveRange = NSRange()
                    let attributes = self.attributesAtIndex(index, longestEffectiveRange: &effectiveRange, inRange: strRange)
                    if let attachment = attributes[NSAttachmentAttributeName] as? NSTextAttachment {
                        attachments.append(attachment)
//                        self.replaceCharactersInRange(effectiveRange, withAttributedString: NSAttributedString(string: "[\(attachment.fileWrapper!.preferredFilename)]"))
                    }
                    index = effectiveRange.location + effectiveRange.length
                } while (index < strRange.length)
            }
            
            return attachments
        }
    }
    
    /// Transfer string stored with attachments. All attachments will be
    /// transfered to format like "[filepath]".
    func transferedStringWithAttachments() -> String {
        let transferedStorage = NSTextStorage(attributedString: self)
        let strRange = NSMakeRange(0, transferedStorage.length)
        if strRange.length > 0 {
            var index = 0
            repeat {
                var effectiveRange = NSRange()
                let attributes = transferedStorage.attributesAtIndex(index, longestEffectiveRange: &effectiveRange, inRange: strRange)
                if let attachment = attributes[NSAttachmentAttributeName] as? NSTextAttachment {
                    guard attachment.fileWrapper != nil else {
                        fatalError("not found fileWrapper in attachment")
                    }
                    guard attachment.fileWrapper!.preferredFilename != nil else {
                        fatalError("not found preferredFilename in attachment.fileWrapper")
                    }
                    transferedStorage.replaceCharactersInRange(effectiveRange, withAttributedString: NSAttributedString(string: "[\(attachment.fileWrapper!.preferredFilename!)]"))
                }
                index = effectiveRange.location + effectiveRange.length
            } while (index < strRange.length)
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
    
    convenience init(markdownString string: String) throws {
        let informationHTML = try MMMarkdown.HTMLStringWithMarkdown(string, extensions: MMMarkdownExtensions.GitHubFlavored)
        
        let informationData = informationHTML.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        try self.init(data: informationData!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
    }
    
}
