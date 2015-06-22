//
//  UIView.swift
//  PolyGe
//
//  Created by king on 15/4/19.
//  Copyright (c) 2015年 king. All rights reserved.
//

import UIKit

func constraint(item1: UIView, attribute1: NSLayoutAttribute, relation: NSLayoutRelation, item2: UIView, attribute2: NSLayoutAttribute, constant: CGFloat = 0.0, multiplier: CGFloat = 1.0) -> NSLayoutConstraint
{
    return NSLayoutConstraint(item: item1, attribute: attribute1, relatedBy: relation, toItem: item2, attribute: attribute2, multiplier: multiplier, constant: constant)
}

func constraint(item1: UIView, attribute1: NSLayoutAttribute, relation: NSLayoutRelation, constant: CGFloat = 0.0, multiplier : CGFloat = 1.0) -> NSLayoutConstraint
{
    return NSLayoutConstraint(item: item1, attribute: attribute1, relatedBy: relation, toItem: nil, attribute: .NotAnAttribute, multiplier: multiplier, constant: constant)
}
extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor(CGColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue.CGColor
        }
    }
    
    @IBInspectable var onePx: Bool {
        get {
            return self.onePx
        }
        set {
            if (onePx == true){
                self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 1 / UIScreen.mainScreen().scale)
            }
        }
    }
    /**
    - returns: true if v is in this view's super view chain
    */
    public func isSuper(v : UIView) -> Bool
    {
        for var s : UIView? = self; s != nil; s = s?.superview {
            if(v == s) {
                return true;
            }
        }
        return false
    }
    
    public func ksconstrain(attribute: NSLayoutAttribute, _ relation: NSLayoutRelation, _ otherView: UIView, _ otherAttribute: NSLayoutAttribute, constant: CGFloat = 0.0, multiplier : CGFloat = 1.0) -> UIView
    {
        self.translatesAutoresizingMaskIntoConstraints = false
        let c = constraint(self, attribute1: attribute, relation: relation, item2: otherView, attribute2: otherAttribute, constant: constant, multiplier: multiplier)
        if isSuper(otherView) {
            otherView.addConstraint(c)
            return self
        }
        else if(otherView.isSuper(self) || otherView == self)
        {
            self.addConstraint(c)
            return self
        }else if(otherView.superview == self.superview){
            self.superview?.addConstraint(c)
            return self
        }
        assert(false)
        return self
    }
    
    public func ksconstrain(attribute: NSLayoutAttribute, _ relation: NSLayoutRelation, constant: CGFloat, multiplier : CGFloat = 1.0) -> UIView
    {
        self.translatesAutoresizingMaskIntoConstraints = false
        let c = constraint(self, attribute1: attribute, relation: relation, constant: constant, multiplier: multiplier)
        self.addConstraint(c)
        return self
    }
    
    public func constrainWidthWithSuper(constant: CGFloat) -> UIView{
        return ksconstrain(.Width, .Equal, self.superview!, .Width,constant: constant)
    }

    public func constrainWidth(constant: CGFloat) -> UIView{
        return ksconstrain(.Width,.Equal,constant: constant)
    }

    public func constrainHeight(constant: CGFloat) -> UIView{
        return ksconstrain(.Height,.Equal,constant: constant)
    }

    public func constrainTop(constant: CGFloat) -> UIView{
        return ksconstrain(.Top,.Equal,self.superview!,.Top,constant: constant)
    }
    public func constrainBottom(constant: CGFloat) -> UIView{
        return ksconstrain(.Bottom,.Equal,self.superview!,.Bottom,constant: constant)
    }
    public func constrainLeading(constant: CGFloat) -> UIView{
        return ksconstrain(.Leading,.Equal,self.superview!,.Leading,constant: constant)
    }
    public func constrainTrailing(constant: CGFloat) -> UIView{
        return ksconstrain(.Trailing,.Equal,self.superview!,.Trailing,constant: constant)
    }
    
    public func constrainCenterX(constant: CGFloat = 0.0) -> UIView{
        return ksconstrain(.CenterX,.Equal,self.superview!,.CenterX,constant: constant)
    }
    
    public func constrainCenterY(constant: CGFloat = 0.0) -> UIView{
        return ksconstrain(.CenterY,.Equal,self.superview!,.CenterY,constant: constant)
    }
    public func viewController() -> UIViewController?{
        for var next = self.nextResponder(); next != nil ;next = next?.nextResponder(){
            if next!.isKindOfClass(UIViewController.classForCoder()) {
                return next as? UIViewController
            }
        }
        return nil
    }
    public func navigationController() -> UINavigationController?{
        if let viewController = navigationController() {
            if let nav = viewController.navigationController {
                return nav
            }
        }
        return nil
    }
    class public func loadXib() -> UIView? {
        let name = NSStringFromClass(self.self)
        return UIView.loadXib(name.pathExtension)
    }
    class public func loadXib(name: String) -> UIView?{
        return NSBundle.mainBundle().loadNibNamed(name, owner: nil, options: nil).first as? UIView
    }
    
}