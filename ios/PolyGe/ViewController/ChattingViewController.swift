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

class ChattingViewController: KSChattingViewController,ListSectionObserver {
    var receiveUserID: UInt64 = 0;
    var lastMessage: LastMessage?
    var monitor: ListMonitor<Message>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupDataSource()
        inputMessageView.delegate = self
        tableView.dataSource = self
    }
    
    func setupDataSource(){
        monitor = CoreStore.monitorList(
            From(Message),
            GroupBy(),
            Where("userID", isEqualTo: NSNumber(unsignedLongLong:self.receiveUserID)),
            OrderBy(.Ascending("createDate"))
        )
        monitor?.addObserver(self)
        lastMessage = CoreStore.fetchOne(
            From(LastMessage),
            Where("userID", isEqualTo: NSNumber(unsignedLongLong:self.receiveUserID))
        )
        if lastMessage == nil {
            CoreStore.defaultStack.beginSynchronous { (transaction) -> Void in
                self.lastMessage = transaction.create(Into<LastMessage>())
                self.lastMessage!.userID = self.receiveUserID
                self.lastMessage!.createDate = NSDate()
                transaction.commit()
            }
        }

    }
    deinit {
        monitor?.removeObserver(self)
    }
    
    func listMonitorWillChange(monitor: ListMonitor<Message>) {
        
        self.tableView.beginUpdates()
    }
    
    func listMonitorDidChange(monitor: ListMonitor<Message>) {
        
        self.tableView.endUpdates()
    }
    // MARK: ListObjectObserver
    
    func listMonitor(monitor: ListMonitor<Message>, didInsertObject object: Message, toIndexPath indexPath: NSIndexPath) {
        
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    func listMonitor(monitor: ListMonitor<Message>, didDeleteObject object: Message, fromIndexPath indexPath: NSIndexPath) {
        
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    func listMonitor(monitor: ListMonitor<Message>, didUpdateObject object: Message, atIndexPath indexPath: NSIndexPath) {
        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
    }
    
    func listMonitor(monitor: ListMonitor<Message>, didMoveObject object: Message, fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        
        self.tableView.deleteRowsAtIndexPaths([fromIndexPath], withRowAnimation: .Automatic)
        self.tableView.insertRowsAtIndexPaths([toIndexPath], withRowAnimation: .Automatic)
    }
    func listMonitor(monitor: ListMonitor<Message>, didInsertSection sectionInfo: NSFetchedResultsSectionInfo, toSectionIndex sectionIndex: Int) {
        
        self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
    }
    
    func listMonitor(monitor: ListMonitor<Message>, didDeleteSection sectionInfo: NSFetchedResultsSectionInfo, fromSectionIndex sectionIndex: Int) {
        
        self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
    }
    
    
}
extension ChattingViewController: UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.monitor?.numberOfSections() ?? 0
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.monitor?.numberOfObjectsInSection(section) ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = KSMessageCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CellId")
        let curMessage = self.monitor![indexPath]
        if indexPath.row > 0{
            curMessage.minuteOffSetStart(self.monitor![NSIndexPath(forRow: indexPath.row-1, inSection: indexPath.section)].createDate, end: curMessage.createDate)
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
            message.createDate = NSDate()
            message.messageData = text.dataUsingEncoding(NSUTF8StringEncoding)!
            message.userID = self.receiveUserID
            message.messageType = .Text
            if KSSocket.sharedInstance.isConnected {
                KSSocket.sharedInstance.writeData(message.toData())
            }
            if let lastMessage = transaction.edit(self.lastMessage) {
                lastMessage.createDate = message.createDate
                lastMessage.info = text
            }

            transaction.commit()
        }
        tableView.scrollToBottom()
    }
    
    func sendMessagePhoto(data: NSData, fileName: String){
        CoreStore.defaultStack.beginSynchronous { (transaction) -> Void in
            let message = transaction.create(Into<Message>())
            message.createDate = NSDate()
            message.userID = self.receiveUserID
            message.messageData = data
            message.messageType = .Picture
            if KSSocket.sharedInstance.isConnected {
                KSSocket.sharedInstance.writeData(message.toData())
            }
            if let lastMessage = transaction.edit(self.lastMessage) {
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
            message.createDate = NSDate()
            message.userID = self.receiveUserID
            message.messageData = voiceData
            message.voiceTime = NSNumber(unsignedChar: voiceTime)
            message.messageType = .Voice
            if KSSocket.sharedInstance.isConnected {
                KSSocket.sharedInstance.writeData(message.toData())
            }
            if let lastMessage = transaction.edit(self.lastMessage) {
                lastMessage.createDate = message.createDate
                lastMessage.info = "[语音]"
            }
            transaction.commit()
        }
        tableView.scrollToBottom()
    }
}
