//
//  KSCoreDataViewModel.swift
//  PolyGe
//
//  Created by king on 15/7/13.
//  Copyright © 2015年 king. All rights reserved.
//

import UIKit
import CoreStore

public class KSCoreDataViewModel<T: NSManagedObject>: NSObject {
    public weak var tableView: UITableView?
    /// Sections to use in the table view.
    public var listMonitor: ListMonitor<T>? {
        willSet {
            if let monitor = listMonitor {
                monitor.removeObserver(self)
            }
        }
        didSet {
            listMonitor?.addObserver(self)
            tableView?.reloadData()
        }
    }
    public init(tableView: UITableView,monitor: ListMonitor<T>? = nil) {
        super.init()
        self.tableView = tableView
        listMonitor = monitor
        self.tableView?.reloadData()
        listMonitor?.addObserver(self)
    }
    deinit {
        listMonitor?.removeObserver(self)
    }
    
}
extension KSCoreDataViewModel: KSDataSource {
    
    public func numberOfSections() -> Int
    {
        return listMonitor?.numberOfSections() ?? 0
    }
    /**
    Returns the number of objects in the specified section
    
    - parameter section: the section index
    */
    public func numberOfObjectsInSection(section: Int) -> Int
    {
        return listMonitor?.numberOfObjectsInSection(section) ?? 0
    }
    
    public func objectAtIndexPath(indexPath: NSIndexPath) -> AnyObject
    {
        return listMonitor![indexPath]
    }
    
    public subscript(indexPath: NSIndexPath) -> T {
        return objectAtIndexPath(indexPath) as! T
    }
    
}

extension KSCoreDataViewModel: ListSectionObserver {
    
    public func listMonitorWillChange(monitor: ListMonitor<T>) {
        
        self.tableView!.beginUpdates()
    }
    
    public func listMonitorDidChange(monitor: ListMonitor<T>) {
        
        self.tableView!.endUpdates()
    }
    // MARK: ListObjectObserver
    
    public func listMonitor(monitor: ListMonitor<T>, didInsertObject object: T, toIndexPath indexPath: NSIndexPath) {
        
        self.tableView!.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    public func listMonitor(monitor: ListMonitor<T>, didDeleteObject object: T, fromIndexPath indexPath: NSIndexPath) {
        
        self.tableView!.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    public func listMonitor(monitor: ListMonitor<T>, didUpdateObject object: T, atIndexPath indexPath: NSIndexPath) {
        //        self.tableView!.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    public func listMonitor(monitor: ListMonitor<T>, didMoveObject object: T, fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        if fromIndexPath != toIndexPath {
            self.tableView!.deleteRowsAtIndexPaths([fromIndexPath], withRowAnimation: .Automatic)
            self.tableView!.insertRowsAtIndexPaths([toIndexPath], withRowAnimation: .Automatic)
        }else{
            self.tableView!.reloadRowsAtIndexPaths([fromIndexPath], withRowAnimation: .Automatic)
            
        }
    }
    public func listMonitor(monitor: ListMonitor<T>, didInsertSection sectionInfo: NSFetchedResultsSectionInfo, toSectionIndex sectionIndex: Int) {
        
        self.tableView!.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
    }
    
    public func listMonitor(monitor: ListMonitor<T>, didDeleteSection sectionInfo: NSFetchedResultsSectionInfo, fromSectionIndex sectionIndex: Int) {
        
        self.tableView!.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
    }
}