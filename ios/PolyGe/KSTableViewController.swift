//
//  BaseNavigationController.swift
//  PolyGe
//
//  Created by king on 15/4/16.
//  Copyright (c) 2015年 king. All rights reserved.
//

import UIKit

class KSTableViewController: UITableViewController,UITableViewDataSource {
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = .None
        tableView.dataSource = self
        tableView.delegate = self
    }
}
