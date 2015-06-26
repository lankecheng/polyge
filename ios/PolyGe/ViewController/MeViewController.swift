//
//  MeViewController.swift
//  PolyGe
//
//  Created by king on 15/4/16.
//  Copyright (c) 2015年 king. All rights reserved.
//

import UIKit

class MeViewController: KSTableViewController {
    var dataSource: [[[String:String]]] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(UITableViewCell.classForCoder(),forCellReuseIdentifier:MainStoryboard.TableViewCellIdentifiers.cell)
        if NSUserDefaults.hasLogin {
            dataSource = [
                [["image":KSUserHelper.sharedInstance.avatar ?? "User","title":KSUserHelper.sharedInstance.uname],
                    ["image":"Friends","title":LocalizedString("Friends")],
                    ["image":"Settings","title":LocalizedString("Settings")],
                    ["image":"Tracking","title":LocalizedString("Tracking")],
                    ["image":"Credit","title":LocalizedString("Credit")],
                    ["image":"Schedule","title":LocalizedString("Schedule")]],
                [["image":"How it works","title":LocalizedString("How it works")],
                    ["image":"Feedback","title":LocalizedString("Feedback")],
                    ["image":"Help","title":LocalizedString("Help")]]
            ]
        }else {
            dataSource = [
                [["image":"User","title":LocalizedString("Longin or Signup")],
                    ["image":"Settings","title":LocalizedString("Settings")]],
                [["image":"How it works","title":LocalizedString("How it works")],
                    ["image":"Feedback","title":LocalizedString("Feedback")],
                    ["image":"Help","title":LocalizedString("Help")]]
            ]
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: UITableViewDataSource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataSource.count
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(MainStoryboard.TableViewCellIdentifiers.cell, forIndexPath: indexPath) as UITableViewCell
        let data = dataSource[indexPath.section][indexPath.row]
        var image = UIImage(named: data["image"]!)

        if indexPath.section == 0 && indexPath.row == 0 {
           image = image?.transformtoScale(4)
        }
        cell.imageView?.image = image
        cell.textLabel?.text = data["title"]
        return cell
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55
    }

    //MARK: UITableViewDelegate
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }else{
            return 20
        }
    }

}
