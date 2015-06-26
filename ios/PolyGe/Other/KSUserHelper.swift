//
//  KSUserHelper.swift
//  PolyGe
//
//  Created by king on 15/5/4.
//  Copyright (c) 2015年 king. All rights reserved.
//

import Foundation
import CoreData
class KSUserHelper {
    static let sharedInstance = KSUserHelper()
    var avatar : String?
    var uname: String
    static func getUser(userID: Int64) -> User? {
        return User.MR_findByAttribute("uid", withValue: NSNumber(longLong: userID))[0] as? User
    }
    init() {
        if let user = KSUserHelper.getUser(NSUserDefaults.userID!) {
            avatar = user.avatar
            uname = user.uname
        }else{
            uname = "xxx"
        }
    }
}