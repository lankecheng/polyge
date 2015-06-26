//
//  UIViewController.swift
//  PolyGe
//
//  Created by king on 15/6/22.
//  Copyright © 2015年 king. All rights reserved.
//

import UIKit
import Aspects
extension UIViewController {
    class public func loadXib() -> UIViewController? {
        let name = NSStringFromClass(self.self)
        return UIViewController.loadXib(name.pathExtension)
    }
    class public func loadXib(name: String) -> UIViewController?{
        return NSBundle.mainBundle().loadNibNamed(name, owner: nil, options: nil).first as? UIViewController
    }    
}