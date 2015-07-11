//
//  KSSocket.swift
//  PolyGe
//
//  Created by king on 15/7/5.
//  Copyright © 2015年 king. All rights reserved.
//

import Foundation
import Starscream
class KSSocket:WebSocket,WebSocketDelegate{
    static let sharedInstance = KSSocket()
    init() {
        super.init(url:  NSURL(scheme: "ws", host: "120.26.212.134:5918", path: "/wsconn?token=\(NSUserDefaults.token)")!)
        self.delegate = self
    }
     func websocketDidConnect(socket: WebSocket) {
        print("websocket is connected")
    }
    
     func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        
    }
     func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        
    }
    
     func websocketDidReceiveData(socket: WebSocket, data: NSData) {
        Message.createMessage(data)
    }
    
}