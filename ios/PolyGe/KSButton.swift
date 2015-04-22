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
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.whiteColor().CGColor
        setBackgroundImage(UIColor.createImageWithColor(UIColor.whiteColor()), forState: UIControlState.Selected)
        setTitleColor(KSColor.tintColor, forState: UIControlState.Selected)
        clipsToBounds = true
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
