//
//  KSPersonListViewController.swift
//  PolyGe
//
//  Created by king on 15/4/16.
//  Copyright (c) 2015年 king. All rights reserved.
//

import UIKit

class KSPersonListViewController: KSTableViewController {
    var personList: [KSUserEntity]?
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: UITableViewDataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personList != nil ? personList!.count: 12
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier(MainStoryboard.TableViewCellIdentifiers.personCell, forIndexPath: indexPath) as! KSPersonListTableViewCell
    }
}
