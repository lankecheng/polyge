//
//  AlamofireSwiftyJSON.swift
//  AlamofireSwiftyJSON
//
//  Created by Pinglin Tang on 14-9-22.
//  Copyright (c) 2014 SwiftyJSON. All rights reserved.
//

import UIKit

import Alamofire
import SwiftyJSON
// MARK: - Request for Swift JSON

extension Request {
    
    /**
    Adds a handler to be called once the request has finished.
    
    :param: completionHandler A closure to be executed once the request has finished. The closure takes 4 arguments: the URL request, the URL response, if one was received, the SwiftyJSON enum, if one could be created from the URL response and data, and any error produced while creating the SwiftyJSON enum.
    
    :returns: The request.
    */
    public func responseSwiftyJSON(completionHandler: (NSURLRequest, NSHTTPURLResponse?, Result<JSON>) -> Void) -> Self {
        return responseSwiftyJSON(nil, options: .AllowFragments, completionHandler:completionHandler)
    }
    
    /**
    Adds a handler to be called once the request has finished.
    
    :param: queue The queue on which the completion handler is dispatched.
    :param: options The JSON serialization reading options. `.AllowFragments` by default.
    :param: completionHandler A closure to be executed once the request has finished. The closure takes 4 arguments: the URL request, the URL response, if one was received, the SwiftyJSON enum, if one could be created from the URL response and data, and any error produced while creating the SwiftyJSON enum.
    
    :returns: The request.
    */
    public func responseSwiftyJSON(queue: dispatch_queue_t? = nil, options: NSJSONReadingOptions = .AllowFragments, completionHandler: (NSURLRequest, NSHTTPURLResponse?, Result<JSON>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: Request.JSONResponseSerializer(options: options), completionHandler: { (request, response, result) in
            if let error = result.error as? NSError {
                UIWindow.hideHUD()
                if error.code == 3840 {
                    UIWindow.showTextHUD("授权失效,请重新登录")
                    APP_DELEGATE.window?.rootViewController?.presentViewController(KSStoryboard.loginNavigationController, animated: true, completion: nil)
                }else{
                    UIWindow.showTextHUD(error.localizedDescription)
                }
                return
            }
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                var responseJSON: JSON
                if let object = result.data {
                    responseJSON = JSON(object)
                } else {
                    responseJSON = JSON.null
                }
                let result1: Result<JSON> = .Success(responseJSON)
                dispatch_async(queue ?? dispatch_get_main_queue(), {
                    completionHandler(self.request!, self.response, result1)
                })
            })
        })
    }
}


