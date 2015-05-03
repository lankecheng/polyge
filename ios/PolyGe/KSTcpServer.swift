//
//  KSTcpServer.swift
//  PolyGe
//
//  Created by king on 15/4/21.
//  Copyright (c) 2015年 king. All rights reserved.
//

import Foundation
import Result
class KSTcpServer {
    static var instance = KSTcpServer()
    var connecting = false
    var connectTimes = 0
    var callBackBlock: (Result<String,NSError> -> Void)?
    init(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "n_receiveTcpLinkConnectCompleteNotification", name: KSNotificationHelp.KSNotificationTcpLinkConnectComplete, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "n_receiveTcpLinkConnectFailureNotification", name: KSNotificationHelp.KSNotificationTcpLinkConnectFailure, object: nil)
    }
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func n_receiveTcpLinkConnectCompleteNotification(notification: NSNotification ) {
        if connecting {
            connecting = false
            dispatch_async(dispatch_get_main_queue()){
                self.callBackBlock!(Result.success("sucess"))
            }
        }
    }
    func n_receiveTcpLinkConnectFailureNotification(notification: NSNotification ) {
        if connecting {
            connecting = false
            dispatch_async(dispatch_get_main_queue()){
                 let error = NSError(domain: NSLocalizedString("连接失败", comment: ""), code: 0, userInfo: nil)
                self.callBackBlock!(Result.failure(error))
            }
        }
    }
    
    func loginTcpServerIP(ip: String,port: Int,block: Result<String,NSError> -> Void) {
        if !connecting {
            connectTimes++
            connecting = true
            callBackBlock = block
            let nowTimes = connectTimes
            let popTime = dispatch_time(DISPATCH_TIME_NOW, (Int64)(10*NSEC_PER_SEC))
            dispatch_after(popTime, dispatch_get_main_queue()){
                if self.connecting && nowTimes == self.connectTimes {
                    self.connecting = false
                    let error = NSError(domain: NSLocalizedString("连接超时", comment: ""), code: 0, userInfo: nil)
                    self.callBackBlock!(Result.failure(error))
                }
            }
            
        }
    }
    
}
