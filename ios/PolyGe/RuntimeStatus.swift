//
//  Status.swift
//  PolyGe
//
//  Created by king on 15/4/16.
//  Copyright (c) 2015年 king. All rights reserved.
//

import Foundation
enum PersonType {
    case Professional
    case Partner
}

enum PersonStatu {
    case onLine
    case offLine
}
enum MsgType: Int {
    case MsgTypeMsgTypeSingleText = 1
    case MsgTypeMsgTypeSingleAudio = 2
    case MsgTypeMsgTypeGroupText = 17
    case MsgTypeMsgTypeGroupAudio = 18
}


class RuntimeStatus {
    static var instance = RuntimeStatus()

    var user: KSUserEntity
    var sessionID = ""
    var groupCount = 0
    var dao = ""
    var token: String?
    var pushToken: String?
    var discoverUrl: String?
    var msfs: String?
    
    init() {
        user = KSUserEntity()
    }
}