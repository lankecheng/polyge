//
//  KSArrayViewModel.swift
//  PolyGe
//
//  Created by king on 15/7/13.
//  Copyright © 2015年 king. All rights reserved.
//

import UIKit

public class KSArrayViewModel{
    public var dataSource = [[]]
    
    public init(dataSource: NSArray){
        self.dataSource = [dataSource]
    }
    public init(dataSource: [NSArray]){
        self.dataSource  = dataSource
    }
}
extension KSArrayViewModel: KSDataSource {
    
    public func numberOfSections() -> Int
    {
        return self.dataSource.count
    }
    /**
    Returns the number of objects in the specified section
    
    - parameter section: the section index
    */
    public func numberOfObjectsInSection(section: Int) -> Int
    {
        return self.dataSource[section].count
    }
    
    public func objectAtIndexPath(indexPath: NSIndexPath) -> AnyObject
    {
        return self.dataSource[indexPath.section][indexPath.row]
    }
}
