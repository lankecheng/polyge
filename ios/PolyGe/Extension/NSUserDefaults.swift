//
//  NSkUserDefaults.swift
//  PolyGe
//
//  Created by king on 15/4/20.
//  Copyright (c) 2015年 king. All rights reserved.
//

import Foundation
import CoreStore
extension NSUserDefaults {
    subscript (key: String) -> AnyObject? {
        get{
            return objectForKey(key)
        }
        set(newValue){
            setObject(newValue, forKey: key)
            synchronize()
        }
    }
    class var loginType: LoginType{
        get{
            return LoginType(rawValue: standardUserDefaults()["loginType"] as? Int ?? LoginType.None.rawValue)!
        }
        set{
            standardUserDefaults()["loginType"] = newValue.rawValue
        }
    }
    class var hasLogin: Bool{
        get{
            return loginType != LoginType.None
        }
    }
    class var host: String{
        get{
            return standardUserDefaults()["host"] as? String ?? "http://120.26.212.134:5918"
        }
        set{
            standardUserDefaults()["host"] = newValue
        }
    }
    class var token: String{
        get{
            return standardUserDefaults()["token"] as? String ?? "virtualtoken"
        }
        set{
            standardUserDefaults()["token"] = newValue
        }
    }
    class var userID: UInt64?{
        get{
        return (standardUserDefaults()["userID"] as? NSNumber)?.unsignedLongLongValue
        }
        set{
            if newValue != self.userID {
                standardUserDefaults()["userID"] = NSNumber(unsignedLongLong: newValue!)
                CoreStore.defaultStack = DataStack()
                CoreStore.addSQLiteStoreAndWait(fileName: "MyStore-\(NSUserDefaults.userID).sqlite")
                KSUserHelper.sharedInstance = KSUserHelper()
            }
        }
    }
    
}
