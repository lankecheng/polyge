//
//  KSChattingModule.swift
//  PolyGe
//
//  Created by king on 15/4/19.
//  Copyright (c) 2015年 king. All rights reserved.
//

import UIKit
class KSChattingModule {
    var messages: NSMutableArray
    var avatars: NSMutableArray
    var users: [String:String]

    var outgoingBubbleImageData: UIImage?
    var incomingBubbleImageData: UIImage?
    
    init() {
        messages = NSMutableArray()
        avatars = NSMutableArray()
        users = [String:String]()
//        let bubbleFactory = JSQMessagesBubbleImageFactory()
//        outgoingBubbleImageData = bubbleFactory.outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
//        incomingBubbleImageData =
//            bubbleFactory.outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleGreenColor())
    }
}