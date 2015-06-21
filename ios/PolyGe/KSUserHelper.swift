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
    static var userID = kUserDefault
    var userIcon: String? = "http://sys.bansuikj.com/uploads/idcard/1428054233-0de32994c23efd12dfa2afaf5c6ae6d6.png"
   
    static func getUser(userID: Int64) -> User? {
        if self.userID == userID {
            let user = User.MR_createEntity()
            user.imageUrl = "http://sys.bansuikj.com/uploads/idcard/1428054233-0de32994c23efd12dfa2afaf5c6ae6d6.png"
            return user
        }
        return User.MR_findByAttribute("pkUser", withValue: NSNumber(longLong: userID))[0] as? User
    }
}