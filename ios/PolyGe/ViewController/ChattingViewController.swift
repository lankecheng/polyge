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
import CoreData

class ChattingViewController: KSChattingViewController {
    //对方uid
    var receiveUserID: UInt64 = 0;
    var socket = WebSocket(url: NSURL(scheme: "ws", host: "120.26.212.134:5918", path: "/wsconn?token=\(NSUserDefaults.token)")!)
    override func viewDidLoad() {
        super.viewDidLoad()
        socket = WebSocket(url: NSURL(scheme: "ws", host: "120.26.212.134:5918", path: "/wsconn?token=\(NSUserDefaults.token)")!)
        socket.delegate = self
        socket.connect()
    }
    override func viewDidDisappear(animated: Bool) {
        self.socket.disconnect()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func processMessage(message: Message) {
        message.receiveUserID = receiveUserID
        self.socket.writeData(message.toData())
    }
}

extension ChattingViewController: WebSocketDelegate{
    func websocketDidConnect(socket: WebSocket) {
        print("websocket is connected")
    }
    
    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        
    }
    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        
    }
    
    func websocketDidReceiveData(socket: WebSocket, data: NSData) {
        Message.createMessage(data)
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }
}
