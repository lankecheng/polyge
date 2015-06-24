//
//  LoginModule.swift
//  PolyGe
//
//  Created by king on 15/4/21.
//  Copyright (c) 2015年 king. All rights reserved.
//

import Foundation
import Result
class LoginModule{
    class func loginWithUsername(name: String, password: String, block: (Result<KSUserEntity,NSError>) -> Void){
        KSHttpServer.getMsgIp(){ (result) in
            if let error = result.error {
                block(Result.failure(error))
            } else if let dic = result.value as? [String:String] {
                let code = Int(dic["code"]!)
                if code == 0 {
                    let priorIP = dic["priorIP"]!
                    let port = Int(dic["port"]!)
                    RuntimeStatus.instance.msfs = dic["msfs"]
                    RuntimeStatus.instance.discoverUrl = dic["discovery"]
                    KSTcpServer.instance.loginTcpServerIP(priorIP, port: port!){
                        (result) in
                        if let error = result.error {
                            block(Result.failure(error))
                        }else {
                            let user = KSUserEntity()
                            
                            block(Result.success(user))
                        }
                        
                    }
                }
            }
        }
    }
}