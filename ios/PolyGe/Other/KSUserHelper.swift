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
    var userIcon: String? = "http://sys.bansuikj.com/uploads/idcard/1428054233-0de32994c23efd12dfa2afaf5c6ae6d6.png"
   
    static func getUser(userID: Int64) -> User? {
        return User.MR_findByAttribute("uid", withValue: NSNumber(longLong: userID))[0] as? User
    }
}