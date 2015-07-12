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
        tableView.registerClass(UITableViewCell.classForCoder(),forCellReuseIdentifier:KSStoryboard.TableViewCellIdentifiers.cell)
        self.setupDataSource()
       
    }
    func setupDataSource() {
        if NSUserDefaults.hasLogin {
            dataSource = [
                [["image":KSUserHelper.sharedInstance.avatar ?? "User","title":KSUserHelper.sharedInstance.uname],
                    ["image":"Friends","title":KSLocalizedString("Friends")],
                    ["image":"Settings","title":KSLocalizedString("Settings")],
                    ["image":"Tracking","title":KSLocalizedString("Tracking")],
                    ["image":"Credit","title":KSLocalizedString("Credit")],
                    ["image":"Schedule","title":KSLocalizedString("Schedule")]],
                [["image":"How it works","title":KSLocalizedString("How it works")],
                    ["image":"Feedback","title":KSLocalizedString("Feedback")],
                    ["image":"Help","title":KSLocalizedString("Help")]]
            ]
        }else {
            dataSource = [
                [["image":"User","title":KSLocalizedString("Longin or Signup")],
                    ["image":"Settings","title":KSLocalizedString("Settings")]],
                [["image":"How it works","title":KSLocalizedString("How it works")],
                    ["image":"Feedback","title":KSLocalizedString("Feedback")],
                    ["image":"Help","title":KSLocalizedString("Help")]]
            ]
        }
        self.tableView.reloadData()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        dataSource[0][0] = ["image":KSUserHelper.sharedInstance.avatar ?? "User","title":KSUserHelper.sharedInstance.uname]
        self.tableView.reloadData()
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
        let cell = tableView.dequeueReusableCellWithIdentifier(KSStoryboard.TableViewCellIdentifiers.cell, forIndexPath: indexPath) as UITableViewCell
        let data = self.dataSource[indexPath.section][indexPath.row]
        var image = UIImage(named: data["image"]!)

        if indexPath.section == 0 && indexPath.row == 0 {
           image = image?.transformtoScale(4)
        }
        cell.imageView?.image = image
        cell.textLabel?.text = data["title"]
        return cell
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
            return 70
        }else{
            return 55
        }
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            if let uid = NSUserDefaults.userID {
                let viewController =  UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(KSStoryboard.XIBIdentifiers.KSPersonViewController) as! KSPersonViewController
                viewController.person = KSUserHelper.getUser(uid)!
                self.navigationController?.pushViewController(
                    viewController, animated: true)
                
            }else{
                let viewController =  UIStoryboard(name: "Login", bundle: NSBundle.mainBundle()).instantiateInitialViewController()
                self.navigationController?.pushViewController(viewController!, animated: true)
            }
        }
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
