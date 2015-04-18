//
//  PersonModel.swift
//  PolyGe
//
//  Created by king on 15/4/16.
//  Copyright (c) 2015年 king. All rights reserved.
//

import UIKit
class PersonModel {
    var userName: String
    var imageUrl: String?
    var image: UIImage?
    var country: String?
    var language: String = "English"
    var occupation: String?
    var interests: String?
    var about: String?
    var audio: AnyObject?
    var comments: String?
    
    init(name: String) {
        userName = name
    }
}