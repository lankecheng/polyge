//
//  KSColor.swift
//  PolyGe
//
//  Created by king on 15/4/17.
//  Copyright (c) 2015年 king. All rights reserved.
//

import UIKit
class KSColor: UIColor {
    //高亮的颜色是5E56A0,状态栏的颜色是827CB8
    static let hightColor = UIColor(hexString: "5E56A0")//5D559F,4B408F
    static let backgroundColor = hightColor.colorWithAlphaComponent(0.8)
    static let tintColor = UIColor(hexString: "827CB8")
    static let titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
}

