//
//  MessageEntity.swift
//  PolyGe
//
//  Created by king on 15/4/19.
//  Copyright (c) 2015年 king. All rights reserved.
//

import Foundation

class MessageEntity {
    var msgID = 0
    static func tableName() -> String{
        return "ks_message"
    }
    static func pkFieldName() -> String{
        return "pk_message"
    }
  
    
}