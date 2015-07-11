//
//  NSObject.swift
//  PolyGe
//
//  Created by king on 15/6/27.
//  Copyright © 2015年 king. All rights reserved.
//

import UIKit
import GCDKit
extension NSObject {
    class func className() -> String {
        return "\(self)".componentsSeparatedByString(".").last!
    }
    func className() -> String {
        return "\(self.dynamicType)".componentsSeparatedByString(".").last!
    }
    class func showTextHUD(text: String) {
        UIWindow.topWindow().showTextHUD(text)
    }

    func showTextHUD(text: String) {
        guard NSThread.isMainThread() else {
            GCDQueue.Main.sync({ () -> Void in
                self.showTextHUD(text)
            })
            return
        }
        if self .isKindOfClass(UIViewController.self) {
            
        }
        let hud = MBProgressHUD.showHUDAddedTo(self.topView(), animated: true)
        hud.labelText =  KSLocalizedString(text)
        hud.mode = .Text
        var duration = Double( KSLocalizedString(text).characters.count)*0.08+0.3
        duration = min(3, max(1, duration))
         GCDQueue.Main.after(duration) { () -> Void in
            if hud.superview != nil {
                hud.removeFromSuperViewOnHide = true
                hud.hide(true)
            }
        }
    }
    class func hideHUD() {
        UIWindow.topWindow().hideHUD()
    }
    func hideHUD() {
        guard NSThread.isMainThread() else {
             GCDQueue.Main.sync{self.hideHUD()}
            return
        }
        MBProgressHUD.hideHUDForView(self.topView(), animated: true)
    }
    func topView() -> UIView {
        if isKindOfClass(UIView) {
            return self as! UIView
        }else if isKindOfClass(UIViewController) {
            return (self as! UIViewController).view
        }else{
            return UIWindow.topWindow()
        }
    }
    
}
