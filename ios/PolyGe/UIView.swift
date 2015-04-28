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
    /**
    :returns: true if v is in this view's super view chain
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
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        let c = constraint(self, attribute, relation, otherView, otherAttribute, constant: constant, multiplier: multiplier)
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
    }
    
    public func ksconstrain(attribute: NSLayoutAttribute, _ relation: NSLayoutRelation, constant: CGFloat, multiplier : CGFloat = 1.0) -> UIView
    {
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        let c = constraint(self, attribute, relation, constant: constant, multiplier: multiplier)
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
    
    public func constrainCenterX(_ constant: CGFloat = 0.0) -> UIView{
        return ksconstrain(.CenterX,.Equal,self.superview!,.CenterX,constant: constant)
    }
    
    public func constrainCenterY(_ constant: CGFloat = 0.0) -> UIView{
        return ksconstrain(.CenterY,.Equal,self.superview!,.CenterY,constant: constant)
    }
    
}