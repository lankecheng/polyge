//
//  UIWindow.swift
//  PolyGe
//
//  Created by king on 15/6/27.
//  Copyright © 2015年 king. All rights reserved.
//

import UIKit
extension UIWindow {
    static func topWindow() -> UIWindow {
        //有inputView或者键盘时，避免提示被挡住，应该选择这个 UITextEffectsWindow 来显示
        return UIApplication.sharedApplication().windows.filter{ $0.className() ==  "UITextEffectsWindow" }.first ?? UIApplication.sharedApplication().keyWindow!
    }
}
