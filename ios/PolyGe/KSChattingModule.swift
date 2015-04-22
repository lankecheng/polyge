//
//  KSChattingModule.swift
//  PolyGe
//
//  Created by king on 15/4/19.
//  Copyright (c) 2015年 king. All rights reserved.
//

import Foundation
import JSQMessagesViewController
class KSChattingModule {
    var messages: NSMutableArray
    var avatars: [String:JSQMessagesAvatarImage]
    var users: [String:String]

    var outgoingBubbleImageData: JSQMessagesBubbleImage
    var incomingBubbleImageData: JSQMessagesBubbleImage
    
    init() {
        messages = NSMutableArray()
        avatars = [String:JSQMessagesAvatarImage]()
        users = [String:String]()
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        outgoingBubbleImageData = bubbleFactory.outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
        incomingBubbleImageData =
            bubbleFactory.outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleGreenColor())
    }
}