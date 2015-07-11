//
//  KMPlaceholderTextView.swift
//
//  Copyright (c) 2015 Zhouqi Mo (https://github.com/MoZhouqi)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit

@IBDesignable
public class KMPlaceholderTextView: UITextView {
    static let defaultiOSPlaceholderColor = UIColor(red: 0.0, green: 0.0, blue: 0.0980392, alpha: 0.22)
    
    @IBInspectable public var placeholder: String = "" {
        didSet {
            placeholderLabel.text = placeholder
        }
    }
    
    @IBInspectable public var placeholderColor: UIColor = KMPlaceholderTextView.defaultiOSPlaceholderColor {
        didSet {
            placeholderLabel.textColor = placeholderColor
        }
    }
    
    public let placeholderLabel: UILabel = UILabel()
    
    override public var font: UIFont? {
        didSet {
            placeholderLabel.font = font
        }
    }
    
    override public var textAlignment: NSTextAlignment {
        didSet {
            placeholderLabel.textAlignment = textAlignment
        }
    }
    
    override public var text: String! {
        didSet {
            textDidChange()
        }
    }
    
    override public var attributedText: NSAttributedString! {
        didSet {
            textDidChange()
        }
    }
    
    override public var textContainerInset: UIEdgeInsets {
        didSet {
            updateConstraintsForPlaceholderLabel()
        }
    }
    
    var placeholderLabelConstraints = [NSLayoutConstraint]()
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "textDidChange",
            name: UITextViewTextDidChangeNotification,
            object: nil)
        
        backgroundColor = UIColor.whiteColor()
        self.layer.borderWidth = kBorderWidth
        self.layer.borderColor = kBorderColor
        self.layer.cornerRadius = kCornerRadius
        
        self.scrollIndicatorInsets = UIEdgeInsetsMake(kCornerRadius, 0, kCornerRadius, 0)
        self.contentInset = UIEdgeInsetsMake(1.0, 0.0, 1.0, 0.0)
        
        self.scrollEnabled = true
        self.scrollsToTop = false
        self.userInteractionEnabled = true
        
        self.font = UIFont.systemFontOfSize(16)
        self.textColor = UIColor.blackColor()
        self.textAlignment = .Natural
        
        self.contentMode = .Redraw
        self.dataDetectorTypes = .None
        self.keyboardAppearance = .Default
        self.keyboardType = .Default
        self.returnKeyType = .Default

        placeholderLabel.font = font
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.textAlignment = textAlignment
        placeholderLabel.text = placeholder
        placeholderLabel.numberOfLines = 0
        placeholderLabel.backgroundColor = UIColor.clearColor()
        addSubview(placeholderLabel)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        updateConstraintsForPlaceholderLabel()
        self.textContainerInset = UIEdgeInsetsMake(4.0, 2.0, 4.0, 2.0)
    }
    
    func updateConstraintsForPlaceholderLabel() {
        var newConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(\(textContainerInset.left + textContainer.lineFragmentPadding))-[placeholder]-(\(textContainerInset.right + textContainer.lineFragmentPadding))-|",
            options: [],
            metrics: nil,
            views: ["placeholder": placeholderLabel])
        newConstraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-(\(textContainerInset.top))-[placeholder]-(>=\(textContainerInset.bottom))-|",
            options: [],
            metrics: nil,
            views: ["placeholder": placeholderLabel])
        removeConstraints(placeholderLabelConstraints)
        addConstraints(newConstraints)
        placeholderLabelConstraints = newConstraints
    }
    
    func textDidChange() {
        placeholderLabel.hidden = !text.isEmpty
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        placeholderLabel.preferredMaxLayoutWidth = textContainer.size.width - textContainer.lineFragmentPadding * 2.0
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self,
            name: UITextViewTextDidChangeNotification,
            object: nil)
    }
    
}
