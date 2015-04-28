//
//  UIImage.swift
//  PolyGe
//
//  Created by king on 15/4/19.
//  Copyright (c) 2015年 king. All rights reserved.
//

import UIKit
extension UIImage {
    func transformtoScale(scale: CGFloat) -> UIImage {
        return UIImage(CGImage: self.CGImage, scale: scale, orientation: .Up)!
        
//        // 创建一个bitmap的context
//        UIGraphicsBeginImageContext(size)
//        // 绘制改变大小的图片
//        drawInRect(CGRectMake(0, 0, size.width, size.height))
//        // 从当前context中创建一个改变大小后的图片
//        let transformedImg=UIGraphicsGetImageFromCurrentImageContext()
//        // 使当前的context出堆栈
//        UIGraphicsEndImageContext()
//        // 返回新的改变大小后的图片
//        return transformedImg
    }
}
