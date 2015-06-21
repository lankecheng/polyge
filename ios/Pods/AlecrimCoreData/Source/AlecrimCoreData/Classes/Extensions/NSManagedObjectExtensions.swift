//
//  NSManagedObjectExtensions.swift
//  AlecrimCoreData
//
//  Created by Vanderlei Martinelli on 2014-06-24.
//  Copyright (c) 2014 Alecrim. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {
    
//    public func inContext(context: Context) -> Self? {
//        return self.inManagedObjectContext(context.managedObjectContext)
//    }
//    
//    public func inManagedObjectContext(otherManagedObjectContext: NSManagedObjectContext) -> Self? {
//        if self.managedObjectContext == otherManagedObjectContext {
//            return self
//        }
//        
//        if self.objectID.temporaryID {
//            if let moc = self.managedObjectContext {
//                do{
//                    try moc.obtainPermanentIDsForObjects([self as NSManagedObject])
//                }catch let error as NSError{
//                    alecrimCoreDataHandleError(error)
//                }
//            }
//            else {
//                return nil
//            }
//        }
//        
//        do{
//            let objectInContext = try otherManagedObjectContext.existingObjectWithID(self.objectID)
//            return unsafeBitCast(objectInContext, self.dynamicType)
//        }catch let error as NSError{
//            alecrimCoreDataHandleError(error)
//            return nil
//        }
//    
    
//    }
    
}

