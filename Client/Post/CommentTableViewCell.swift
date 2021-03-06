//
//  CommentTableViewCell.swift
//  Hackers2
//
//  Created by Weiran Zhang on 07/06/2014.
//  Copyright (c) 2014 Glass Umbrella. All rights reserved.
//

import Foundation
import UIKit


class CommentTableViewCell : UITableViewCell, UITextViewDelegate {
    
    var delegate: CommentDelegate?
    
    var level: Int = 0 {
        didSet { updateIndentPadding() }
    }
    
    var comment: CommentModel? {
        didSet {
            level = comment!.level
            datePostedLabel.text = comment?.dateCreatedString
            authorLabel.text = comment?.authorUsername
            
            if let textView = commentTextView {
                let commentFont = UIFont.systemFontOfSize(15) //UIFont(name: "HelveticaNeue-Light", size: 15)
                let commentTextColor = UIColor.darkGrayColor()
                let lineSpacing = 4 as CGFloat
                
                let commentAttributedString = NSMutableAttributedString(string: comment!.text)
                let paragraphStyle = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
                paragraphStyle.lineSpacing = lineSpacing
                
                let commentRange = NSMakeRange(0, commentAttributedString.length)
                
                commentAttributedString.addAttribute(NSFontAttributeName, value: commentFont, range: commentRange)
                commentAttributedString.addAttribute(NSForegroundColorAttributeName, value: commentTextColor, range: commentRange)
                commentAttributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: commentRange)
                
                textView.attributedText = commentAttributedString.copy() as! NSAttributedString
            }
        }
    }
    
    
    @IBOutlet var commentTextView: UITextView!
    @IBOutlet var authorLabel : UILabel!
    @IBOutlet var datePostedLabel : UILabel!
    @IBOutlet var leftPaddingConstraint : NSLayoutConstraint!
    
    override func awakeFromNib() {
        contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CommentTableViewCell.cellTapped(_:))))
        exclusiveTouch = true
        contentView.exclusiveTouch = true
    }
    
    func cellTapped(gestureRecognizer: UITapGestureRecognizer) {
        delegate?.commentTapped(self)
        setSelected(!selected, animated: false)
    }
    
    func updateIndentPadding() {
        let levelIndent = 15
        let padding = CGFloat(levelIndent * (level + 1))
        leftPaddingConstraint.constant = padding
    }
    
    // MARK - UITextViewDelegate
    
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        if let _ = delegate {
            delegate!.linkTapped(URL, sender: textView)
            return false
        }
        return true
    }
    
}