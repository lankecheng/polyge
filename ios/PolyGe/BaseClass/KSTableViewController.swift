//
//  BaseNavigationController.swift
//  PolyGe
//
//  Created by king on 15/4/16.
//  Copyright (c) 2015年 king. All rights reserved.
//

import UIKit

class KSTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = .None
        tableView.dataSource = self
        tableView.delegate = self
        let footView = UIView(frame: CGRectMake(0, 0, tableView.frame.width, 1))
        footView.backgroundColor = UIColor.whiteColor()
        tableView.tableFooterView = footView
    }
}
