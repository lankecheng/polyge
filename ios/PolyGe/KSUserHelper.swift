//
//  KSUserHelper.swift
//  PolyGe
//
//  Created by king on 15/5/4.
//  Copyright (c) 2015年 king. All rights reserved.
//

import Foundation
import CoreData
class KSUserHelper {
    
    static let sharedInstance = KSUserHelper()
    static var userID = kUserDefault
    var userIcon: String? = "http://sys.bansuikj.com/uploads/idcard/1428054233-0de32994c23efd12dfa2afaf5c6ae6d6.png"
   
    static func getUser(userID: Int64) -> User? {
        if self.userID == userID {
            let user = User.create() as! User
            user.imageUrl = "http://sys.bansuikj.com/uploads/idcard/1428054233-0de32994c23efd12dfa2afaf5c6ae6d6.png"
            return user
        }
        //1
        let fetchRequest = NSFetchRequest(entityName:"User")
        fetchRequest.predicate = NSPredicate(format: "pkUser=\(userID)")
        //2
        var error: NSError?
        let fetchedResults =
        kManagedContext.executeFetchRequest(fetchRequest,
            error: &error) as! [User]?
        if fetchedResults?.count > 0 {
            return fetchedResults![0]
        }
        return nil
    }
}