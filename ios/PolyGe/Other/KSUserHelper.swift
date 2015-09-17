//
//  KSUserHelper.swift
//  PolyGe
//
//  Created by king on 15/5/4.
//  Copyright (c) 2015年 king. All rights reserved.
//

import Foundation
import CoreStore
class KSUserHelper {
    static var sharedInstance = KSUserHelper()
    var avatar: String?
    var uname: String
    init() {
        if let user = User.getUser(NSUserDefaults.userID!) {
            avatar = user.avatar
            uname = user.uname
        }else{
            uname = "xxx"
        }
    }
    
}