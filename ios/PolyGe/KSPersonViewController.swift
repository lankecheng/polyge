//
//  KSPersonViewController.swift
//  PolyGe
//
//  Created by king on 15/4/17.
//  Copyright (c) 2015年 king. All rights reserved.
//

import UIKit

class KSPersonViewController: UITableViewController,UITableViewDelegate {
    var person = PersonModel(name: "wangjb")
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        let nibView = NSBundle.mainBundle().loadNibNamed(MainStoryboard.XIBIdentifiers.personHeaderView, owner: nil, options: nil)
        let headerView = nibView[0] as? UIView
        headerView?.frame = CGRectMake(0, 0, tableView.frame.width, 285)
        headerView?.backgroundColor = KSColor.tintColor
        tableView.tableHeaderView = headerView
        let footView = UIView(frame: CGRectMake(0, 0, tableView.frame.width, 1))
        footView.backgroundColor = UIColor.whiteColor()
        tableView.tableFooterView = footView
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let top = scrollView.contentInset.top
        if scrollView.contentOffset.y < top {
            scrollView.contentOffset.y = top
        }
    }
    
    //MARK: UITableViewDelegate
    
    
    //MARK: UITableViewDataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var identifier = MainStoryboard.TableViewCellIdentifiers.subtitleCell
        if indexPath.row == 5 {
            identifier = MainStoryboard.TableViewCellIdentifiers.playAudioCell
        }else if indexPath.row == 7 {
            identifier = MainStoryboard.TableViewCellIdentifiers.reportAbuseCell
        }
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! UITableViewCell
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Native language"
            cell.detailTextLabel?.text = person.language
        case 1:
            cell.textLabel?.text = "Country"
            cell.detailTextLabel?.text = person.country
        case 2:
            cell.textLabel?.text = "Occupation"
            cell.detailTextLabel?.text = person.occupation
        case 3:
            cell.textLabel?.text = "Hobbies & interests"
            cell.detailTextLabel?.text = person.interests
        case 4:
            cell.textLabel?.text = "About me"
            cell.detailTextLabel?.text = person.about
        case 5:
           break
        case 6:
            cell.textLabel?.text = "User comments"
            cell.detailTextLabel?.text = person.comments
        case 7:
           break

        default:
           break
        }
        return cell
        
    }
    
}
