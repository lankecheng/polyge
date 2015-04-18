//
//  SecondViewController.swift
//  PolyGe
//
//  Created by king on 15/4/16.
//  Copyright (c) 2015年 king. All rights reserved.
//

import UIKit

class SearchViewController: KSTabTableViewController {

    let conditions = ["language","Topic","Price","Seats"]
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let footView = UIView(frame: CGRectMake(0, 0, tableView.frame.width, 1))
        footView.backgroundColor = UIColor.whiteColor()
        tableView.tableFooterView = footView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //MARK: UITableViewDataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if personType == .Professional{
            return conditions.count+1
        }else {
            return conditions.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var identifier = MainStoryboard.TableViewCellIdentifiers.subtitleCell
        
        if (personType == .Professional && indexPath.row == conditions.count) || (personType == .Partner && indexPath.row == conditions.count-1 ) {
            return tableView.dequeueReusableCellWithIdentifier(MainStoryboard.TableViewCellIdentifiers.searchCell, forIndexPath: indexPath) as! UITableViewCell
        }else {
            let cell = tableView.dequeueReusableCellWithIdentifier(MainStoryboard.TableViewCellIdentifiers.subtitleCell, forIndexPath: indexPath) as! UITableViewCell
            cell.textLabel?.text = conditions[indexPath.row]
            return cell

        }
    }
    
}

