//
//  UIViewController.swift
//  PolyGe
//
//  Created by king on 15/6/22.
//  Copyright © 2015年 king. All rights reserved.
//

import UIKit
extension UIViewController {
    class public func loadXib() -> UIViewController? {
        return UIViewController.loadXib(self.className())
    }
    class public func loadXib(name: String) -> UIViewController?{
        return NSBundle.mainBundle().loadNibNamed(name, owner: nil, options: nil).first as? UIViewController
    }
    public func ksNavigationController() -> UINavigationController?{
        if let nav = self as? UINavigationController {
            return nav
        }else if let tabBar = self as? UITabBarController {
            return tabBar.selectedViewController?.ksNavigationController()
        }
        return self.navigationController
    }

}