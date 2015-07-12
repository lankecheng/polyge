//
//  KSUserHelper.swift
//  PolyGe
//
//  Created by king on 15/5/4.
//  Copyright (c) 2015年 king. All rights reserved.
//

import Foundation
import CoreStore
import RxSwift
class KSUserHelper {
    static var sharedInstance = KSUserHelper()
    var avatar: String?
    var uname: String
    static func getUser(userID: UInt64) -> User? {
        return  CoreStore.fetchOne(
            From(User),
            Where("uid", isEqualTo: NSNumber(unsignedLongLong:userID))
            )
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