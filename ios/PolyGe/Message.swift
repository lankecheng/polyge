//
//  Message.swift
//  PolyGe
//
//  Created by king on 15/5/4.
//  Copyright (c) 2015年 king. All rights reserved.
//

import Foundation
import CoreData
enum MessageType : Int8{//当前消息的类型
    case Text = 0//文字
    case Picture = 1//图片
    case Voice = 2//声音
}

enum MessageFrom{//当前消息发送方
    case Me//自己
    case Other//别人
}

enum MessageState{//当前发送消息状态
    case Successed//发送成功
    case Sending//发送中
    case Failed//发送失败
}
@objc(Message)
class Message: NSManagedObject {
    
    @NSManaged var pkMessage: String
    @NSManaged var createDate: NSDate
    @NSManaged var messageTypeValue: NSNumber
    @NSManaged var createUserID: NSNumber
    @NSManaged var messageData: NSData
    @NSManaged var voiceTime: NSNumber
    
    var messageType: MessageType{
        get{
            return MessageType(rawValue: self.messageTypeValue.charValue)!
        }
        set{
            self.messageTypeValue = NSNumber(char: newValue.rawValue)
        }
    }
    var userIcon: String? {
        get{
            let user = KSUserHelper.getUser(createUserID)
            return user?.imageUrl
        }
    }
    var userName: String?{
        get{
            let user = KSUserHelper.getUser(createUserID)
            return user?.userName
        }
    }
    
    
    var from: MessageFrom {
        get{
            if self.createUserID == KSUserHelper.userID {
                return .Me
            }
            return .Other
        }
    }
    
    
    var state: MessageState = .Successed// 默认消息发送成功
    
    var showDateLabel = true
    
    func minuteOffSetStart(start: NSDate?, end: NSDate){
        if start == nil{
            self.showDateLabel = true
            return
        }
        
        var timeInterval = end.timeIntervalSinceDate(start!)
        //相距3分钟显示时间Label
        println(timeInterval)
        if fabs(timeInterval) > 3*60{
            self.showDateLabel = true
        }else{
            self.showDateLabel = false
        }
    }
    
}

