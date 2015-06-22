//
//  KSHttpServer.swift
//  PolyGe
//
//  Created by king on 15/4/21.
//  Copyright (c) 2015年 king. All rights reserved.
//

import Foundation
import Alamofire
import Result
class KSHttpServer {
    class func getMsgIp(block: Result<NSDictionary,NSError> -> Void){
//        Alamofire.request(.GET,
//            URLString: NSUserDefaults.standardUserDefaults()["ipaddress"] as! String,
//            parameters:nil)
//            .response { (request, response, data, error) in
//                let result: Result<NSDictionary,NSError>
//                if let responseObject = data as? NSData {
//                    do{
//                          let responseDictionary =  try NSJSONSerialization.JSONObjectWithData(responseObject, options: .MutableContainers) as? NSDictionary
//                        return Result(responseDictionary)
//                    }catch let error as NSError{
//                        return Result(error: error)
//                    }
//                }else{
//                    result = Result.failure(error!)
//                }
//                block(result)
//        }
    }
}
