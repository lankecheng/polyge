//
//  KSViewModel.swift
//  PolyGe
//
//  Created by king on 15/6/26.
//  Copyright © 2015年 king. All rights reserved.
//

import Foundation

public protocol KSDataSource {
    /**
    Returns the number of sections
    */
    func numberOfSections() -> Int
    /**
    Returns the number of objects in the specified section
    
    - parameter section: the section index
    */
    func numberOfObjectsInSection(section: Int) -> Int
    
    func objectAtIndexPath(indexPath: NSIndexPath) -> AnyObject
}
extension KSDataSource {
    public subscript(indexPath: NSIndexPath) -> AnyObject {
        return objectAtIndexPath(indexPath)
    }
}