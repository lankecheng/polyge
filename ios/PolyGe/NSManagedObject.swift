//
//  NSManagedObject.swift
//  PolyGe
//
//  Created by king on 15/5/6.
//  Copyright (c) 2015年 king. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject
{
    public class func modelName() -> String
    {
        return NSStringFromClass(self).componentsSeparatedByString(".").last!
    }
    public class func create() -> NSManagedObject{
        let managedObjectClass = self as NSManagedObject.Type
        var object = NSEntityDescription.insertNewObjectForEntityForName(managedObjectClass.modelName(), inManagedObjectContext: kManagedContext) as! NSManagedObject
        return object.self
    }
}