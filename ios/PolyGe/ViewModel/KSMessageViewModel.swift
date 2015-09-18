//
//  KSMessageViewModel.swift
//  PolyGe
//
//  Created by king on 15/7/13.
//  Copyright © 2015年 king. All rights reserved.
//

import UIKit
import CoreStore

class KSMessageViewModel: KSCoreDataViewModel<Message> {
    var receiveUserID: UInt64
    var lastMessage: LastMessage

    init(tableView: UITableView,receiveUserID: UInt64) {
        let monitor = CoreStore.monitorList(
            From(Message),
            Where("userID", isEqualTo: NSNumber(unsignedLongLong:receiveUserID)),
            OrderBy(.Ascending("createDate"))
        )
        self.receiveUserID = receiveUserID
        self.lastMessage = LastMessage.getLastMessage(receiveUserID)
        super.init(tableView: tableView, monitor: monitor)
    }
}
