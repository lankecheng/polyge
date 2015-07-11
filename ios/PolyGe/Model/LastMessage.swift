//
//  LastMessage.swift
//  
//
//  Created by king on 15/7/9.
//
//

import Foundation
import CoreData

@objc(LastMessage)
class LastMessage: NSManagedObject {
    @NSManaged var createDate: NSDate
    @NSManaged var info: String
    @NSManaged var userID: UInt64

}
