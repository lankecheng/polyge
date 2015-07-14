//
//  BaseNavigationController.swift
//  PolyGe
//
//  Created by king on 15/4/16.
//  Copyright (c) 2015年 king. All rights reserved.
//

import UIKit
import CoreStore

class KSTableViewController: UITableViewController {
    var viewModel: KSDataSource?
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = .None
        tableView.dataSource = self
        tableView.delegate = self
        let footView = UIView(frame: CGRectMake(0, 0, tableView.frame.width, 1))
        footView.backgroundColor = UIColor.whiteColor()
        tableView.tableFooterView = footView
        self.view.backgroundColor = UIColor.whiteColor()
    }
    // MARK: UITableViewDataSource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.viewModel?.numberOfSections() ?? 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.viewModel?.numberOfObjectsInSection(section) ?? 0
    }
    
    // MARK: UITableViewDelegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
}


