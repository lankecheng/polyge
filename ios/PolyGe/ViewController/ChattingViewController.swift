//
//  ChattingViewController.swift
//  PolyGe
//
//  Created by king on 15/4/26.
//  Copyright (c) 2015年 king. All rights reserved.
//

import UIKit
import Starscream
import CryptoSwift
import CoreStore

class ChattingViewController: KSChattingViewController {
    var receiveUserID: UInt64 = 0;
    var viewModel: KSMessageViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = KSMessageViewModel(tableView: self.tableView, receiveUserID: self.receiveUserID)
        inputMessageView.delegate = self
        tableView.dataSource = self
    }
}
extension ChattingViewController: UITableViewDataSource{
    // MARK: UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.viewModel?.numberOfSections() ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.viewModel?.numberOfObjectsInSection(section) ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = KSMessageCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CellId")
        let curMessage = self.viewModel![indexPath]
        if indexPath.row > 0{
            curMessage.minuteOffSetStart(self.viewModel![NSIndexPath(forRow: indexPath.row-1, inSection: indexPath.section)].createDate, end: curMessage.createDate)
        }else{
            curMessage.minuteOffSetStart(nil, end: curMessage.createDate)
        }
        cell.setMessageFrame(curMessage)
        return cell
    }
}

extension ChattingViewController: KSInputMessageViewDelegate{
    func sendMessageText(text: String) {
        CoreStore.defaultStack.beginSynchronous { (transaction) -> Void in
            let message = transaction.create(Into<Message>())
            message.from = true
            message.createDate = NSDate()
            message.messageData = text.dataUsingEncoding(NSUTF8StringEncoding)!
            message.userID = self.receiveUserID
            message.messageType = .Text
            if KSSocket.sharedInstance.isConnected {
                KSSocket.sharedInstance.writeData(message.toData())
            }
            if let lastMessage = transaction.edit(self.viewModel!.lastMessage) {
                lastMessage.createDate = message.createDate
                lastMessage.info = text
            }

            transaction.commitAndWait()
        }
        tableView.scrollToBottom()
    }
    
    func sendMessagePhoto(data: NSData, fileName: String){
        CoreStore.defaultStack.beginSynchronous { (transaction) -> Void in
            let message = transaction.create(Into<Message>())
            message.from = true
            message.createDate = NSDate()
            message.userID = self.receiveUserID
            message.messageData = data
            message.messageType = .Picture
            if KSSocket.sharedInstance.isConnected {
                KSSocket.sharedInstance.writeData(message.toData())
            }
            if let lastMessage = transaction.edit(self.viewModel!.lastMessage) {
                lastMessage.createDate = message.createDate
                lastMessage.info = "[图片]"
            }
            transaction.commit()
        }
        tableView.scrollToBottom()
    }
    func sendMessageVoice(voiceData: NSData,voiceTime: UInt8){
        CoreStore.defaultStack.beginSynchronous { (transaction) -> Void in
            let message = transaction.create(Into<Message>())
            message.from = true
            message.createDate = NSDate()
            message.userID = self.receiveUserID
            message.messageData = voiceData
            message.voiceTime = NSNumber(unsignedChar: voiceTime)
            message.messageType = .Voice
            if KSSocket.sharedInstance.isConnected {
                KSSocket.sharedInstance.writeData(message.toData())
            }
            if let lastMessage = transaction.edit(self.viewModel!.lastMessage) {
                lastMessage.createDate = message.createDate
                lastMessage.info = "[语音]"
            }
            transaction.commit()
        }
        tableView.scrollToBottom()
    }
}
