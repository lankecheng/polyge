//
//  Message.swift
//  PolyGe
//
//  Created by king on 15/5/4.
//  Copyright (c) 2015年 king. All rights reserved.
//

import Foundation
import CoreStore
import CryptoSwift

enum MessageType : UInt8{//当前消息的类型
    case Text = 0//文字
    case Picture = 1//图片
    case Voice = 2//声音
}
enum MessageState{//当前发送消息状态
    case Successed//发送成功
    case Sending//发送中
    case Failed//发送失败
}
@objc(Message)
class Message: NSManagedObject {
    
    @NSManaged var createDate: NSDate
    @NSManaged var from: Bool//true：本人发送出去的。false：别人发送过来
    @NSManaged var userID: UInt64
    @NSManaged var messageData: NSData
    @NSManaged var messageTypeValue: NSNumber
    @NSManaged var pkMessage: String
    @NSManaged var voiceTime: NSNumber
    
    var messageType: MessageType{
        get{
            return MessageType(rawValue: self.messageTypeValue.unsignedCharValue)!
        }
        set{
            self.messageTypeValue = NSNumber(unsignedChar: newValue.rawValue)
        }
    }
    var userIcon: String? {
        get{
            let user = KSUserHelper.getUser(userID)
            return user?.avatar
        }
    }
    var userName: String?{
        get{
            let user = KSUserHelper.getUser(userID)
            return user?.avatar
        }
    }
    
    var state: MessageState = .Successed// 默认消息发送成功
    
    var showDateLabel = true
    
    func minuteOffSetStart(start: NSDate?, end: NSDate){
        if start == nil{
            self.showDateLabel = true
            return
        }
        
        let timeInterval = end.timeIntervalSinceDate(start!)
        //相距3分钟显示时间Label
        if fabs(timeInterval) > 3*60{
            self.showDateLabel = true
        }else{
            self.showDateLabel = false
        }
    }
    func toData() -> NSData {
        let data = NSMutableData()
        data.appendUInt64(NSUserDefaults.userID!)
        data.appendUInt64(userID)
        data.appendUInt8(messageTypeValue.unsignedCharValue)
        data.appendUInt64(UInt64(createDate.timeIntervalSince1970))
        data.appendData(messageData)
        if messageType == .Voice {
            data.appendUInt8(voiceTime.unsignedCharValue)
        }
        data.appendData(Hash.crc32(data).calculate()!)
        return data
    }
    class func createMessage(data: NSData){
        guard data.length > 29 else{
            return
        }
        guard data.subdataWithRange(NSMakeRange(0, data.length - 4)).crc32() == data.subdataWithRange(NSMakeRange(data.length - 4, 4)) else{
            return
        }
        
        var createUserID: UInt64 = 0
        var receiveUserID: UInt64 = 0
        data.getBytes(&createUserID, length: 8)
        data.getBytes(&receiveUserID, range: NSMakeRange(8,8))
        createUserID = UInt64(bigEndian: createUserID)
        receiveUserID = UInt64(bigEndian: receiveUserID)
        guard createUserID == NSUserDefaults.userID || receiveUserID == NSUserDefaults.userID else{
            return
        }
        CoreStore.beginSynchronous { (transaction) -> Void in
            let message = transaction.create(Into<Message>())
            if createUserID == NSUserDefaults.userID {
                message.from = true
                message.userID = receiveUserID
            }else{
                message.from = false
                message.userID = createUserID
            }
            
            var messageType: UInt8 = 0
            data.getBytes(&messageType, range: NSMakeRange(16,1))
            message.messageTypeValue = NSNumber(unsignedChar: messageType)
            var timeInterval: UInt64 = 0
            data.getBytes(&timeInterval, range: NSMakeRange(17,8))
            timeInterval = UInt64(bigEndian: timeInterval)
            message.createDate = NSDate(timeIntervalSince1970: Double(timeInterval))
            if message.messageType == .Voice {
                message.messageData = data.subdataWithRange(NSMakeRange(25, data.length - 30))
                data.getBytes(&message.voiceTime, range: NSMakeRange(data.length - 5,1))
            }else{
                message.messageData = data.subdataWithRange(NSMakeRange(25, data.length - 29))
            }
            transaction.commit()
        }
    }
    
}

