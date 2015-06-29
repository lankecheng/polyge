//
//  User.swift
//  PolyGe
//
//  Created by king on 15/5/4.
//  Copyright (c) 2015年 king. All rights reserved.
//

import Foundation
import CoreData
import MJExtension

@objc(User)
class User: NSManagedObject {
    @NSManaged var about: String?
    @NSManaged var audio: String?
    @NSManaged var country: String?
    @NSManaged var avatar: String?
    @NSManaged var interest: String?
    @NSManaged var language: String?
    @NSManaged var occupation: String?
    @NSManaged var uid: UInt64
    @NSManaged var uname: String
    @NSManaged var gender: NSNumber?
    @NSManaged var user_type: NSNumber?
    
    override static func replacedKeyFromPropertyName() -> [NSObject : AnyObject]! {
        return ["about":"description",
                    "occupation":"occup"]
    }
    

}
