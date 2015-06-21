//
//  Message.swift
//  PolyGe
//
//  Created by king on 15/5/4.
//  Copyright (c) 2015年 king. All rights reserved.
//

import Foundation
import CoreData
import AlecrimCoreData
enum MessageType : Int16{//当前消息的类型
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
    
    @NSManaged var createDate: NSDate
    @NSManaged var createUserID: Int64
    @NSManaged var messageData: NSData
    @NSManaged var messageTypeValue: Int16
    @NSManaged var pkMessage: String
    @NSManaged var voiceTime: Int16
    
    var messageType: MessageType{
        get{
            return MessageType(rawValue: self.messageTypeValue)!
        }
        set{
            self.messageTypeValue = newValue.rawValue
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
        
        let timeInterval = end.timeIntervalSinceDate(start!)
        //相距3分钟显示时间Label
        if fabs(timeInterval) > 3*60{
            self.showDateLabel = true
        }else{
            self.showDateLabel = false
        }
    }
    
}
extension Message {
    
    static let createDate = AlecrimCoreData.Attribute<NSDate?>("createDate")
    static let createUserID = AlecrimCoreData.Attribute<Int64?>("createUserID")
    static let messageData = AlecrimCoreData.Attribute<NSData?>("messageData")
    static let messageTypeValue = AlecrimCoreData.Attribute<Int16?>("messageTypeValue")
    static let pkMessage = AlecrimCoreData.Attribute<String?>("pkMessage")
    static let voiceTime = AlecrimCoreData.Attribute<Int16?>("voiceTime")
    
}

public class MessageAttribute<T>: AlecrimCoreData.SingleEntityAttribute<T> {
    
    public override init(_ name: String) { super.init(name) }
    
    public lazy var createDate: AlecrimCoreData.Attribute<NSDate?> = { AlecrimCoreData.Attribute<NSDate?>("\(self.___name).createDate") }()
    public lazy var createUserID: AlecrimCoreData.Attribute<Int64?> = { AlecrimCoreData.Attribute<Int64?>("\(self.___name).createUserID") }()
    public lazy var messageData: AlecrimCoreData.Attribute<NSData?> = { AlecrimCoreData.Attribute<NSData?>("\(self.___name).messageData") }()
    public lazy var messageTypeValue: AlecrimCoreData.Attribute<Int16?> = { AlecrimCoreData.Attribute<Int16?>("\(self.___name).messageTypeValue") }()
    public lazy var pkMessage: AlecrimCoreData.Attribute<String?> = { AlecrimCoreData.Attribute<String?>("\(self.___name).pkMessage") }()
    public lazy var voiceTime: AlecrimCoreData.Attribute<Int16?> = { AlecrimCoreData.Attribute<Int16?>("\(self.___name).voiceTime") }()
    
}


