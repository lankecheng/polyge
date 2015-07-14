//
//  LastMessage.swift
//
//
//  Created by king on 15/7/9.
//
//

import Foundation
import CoreStore

@objc(LastMessage)
class LastMessage: NSManagedObject {
    @NSManaged var createDate: NSDate
    @NSManaged var info: String
    @NSManaged var userID: UInt64
    
    static func getLastMessage(userID: UInt64) -> LastMessage {
        var lastMessage = CoreStore.fetchOne(
            From(LastMessage),
            Where("userID", isEqualTo: NSNumber(unsignedLongLong:userID))
        )
        
        if lastMessage == nil {
            CoreStore.defaultStack.beginSynchronous { (transaction) -> Void in
                lastMessage = transaction.create(Into<LastMessage>())
                lastMessage!.userID = userID
                lastMessage!.createDate = NSDate()
                transaction.commit()
            }
        }
        return lastMessage!
    }
        
}
