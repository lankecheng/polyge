//
//  KSButton.swift
//  PolyGe
//
//  Created by king on 15/4/16.
//  Copyright (c) 2015年 king. All rights reserved.
//

import UIKit


class KSButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setBackgroundImage(UIColor.createImageWithColor(KSColor.hightColor), forState: UIControlState.Selected)
        setTitleColor(UIColor.whiteColor(), forState: UIControlState.Selected)
        setTitleColor(KSColor.hightColor, forState: UIControlState.Normal)
        clipsToBounds = true
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
