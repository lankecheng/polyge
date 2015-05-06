//
//  User.swift
//  PolyGe
//
//  Created by king on 15/5/4.
//  Copyright (c) 2015年 king. All rights reserved.
//

import Foundation
import CoreData

@objc(User)
class User: NSManagedObject {

    @NSManaged var pkUser: NSNumber
    @NSManaged var userName: String
    @NSManaged var country: String
    @NSManaged var language: String
    @NSManaged var comments: String
    @NSManaged var audio: NSData
    @NSManaged var about: String
    @NSManaged var imageUrl: String
    @NSManaged var interests: String
    @NSManaged var occupation: String
    

}
