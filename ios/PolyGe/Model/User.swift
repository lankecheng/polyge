//
//  User.swift
//  PolyGe
//
//  Created by king on 15/5/4.
//  Copyright (c) 2015年 king. All rights reserved.
//

import Foundation
import ObjectMapper
@objc(User)
class User: NSManagedObject,Mappable {
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
    
//    init() {
//       super.init(entity: NSEntityDescription(), insertIntoManagedObjectContext: nil)
//    }
    convenience required init?(_ map: Map) {
        self.init()
        mapping(map)
    }
    func mapping(map: Map){
        uid    <- map["uid"]
        uname         <- map["uname"]
        about      <- map["description"]
        audio      <- map["audio"]
        country      <- map["country"]
        avatar      <- map["avatar"]
        interest      <- map["interest"]
        language  <- map["language"]
        occupation  <- map["occup"]
        gender      <- map["gender"]
        user_type       <- map["user_type"]
    }
}
