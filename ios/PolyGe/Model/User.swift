//
//  User.swift
//  PolyGe
//
//  Created by king on 15/5/4.
//  Copyright (c) 2015年 king. All rights reserved.
//

import Foundation
import SwiftyJSON
@objc(User)
class User: NSManagedObject {
    @NSManaged var uid: UInt64
    @NSManaged var uname: String
    @NSManaged var about: String?
    @NSManaged var audio: String?
    @NSManaged var country: String?
    @NSManaged var avatar: String?
    @NSManaged var interest: String?
    @NSManaged var language: String?
    @NSManaged var occupation: String?
    @NSManaged var gender: NSNumber?
    @NSManaged var user_type: NSNumber?
    
//    func mapping(map: Map){
//        uid    <- map["uid"]
//        uname         <- map["uname"]
//        about      <- map["description"]
//        audio      <- map["audio"]
//        country      <- map["country"]
//        avatar      <- map["avatar"]
//        interest      <- map["interest"]
//        language  <- map["language"]
//        occupation  <- map["occup"]
//        gender      <- map["gender"]
//        user_type       <- map["user_type"]
//    }
    func fromJSON(json: JSON) {
        uid = json["uid"].uInt64Value
        uname = json["uname"].stringValue
        about  = json["description"].string
        audio  = json["audio"].string
        country  = json["country"].string
        avatar = json["avatar"].string
        interest  = json["interest"].string
        language  = json["language"].string
        occupation  = json["occup"].string
        gender    = json["gender"].number
        user_type = json["user_type"].number
    }
}
