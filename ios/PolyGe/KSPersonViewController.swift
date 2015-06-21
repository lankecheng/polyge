//
//  KSPersonViewController.swift
//  PolyGe
//
//  Created by king on 15/4/17.
//  Copyright (c) 2015年 king. All rights reserved.
//

import UIKit

class KSPersonViewController: KSTableViewController {
    var person = KSUserEntity()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView?.backgroundColor = KSColor.tintColor
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

    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            return 44
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var identifier = MainStoryboard.TableViewCellIdentifiers.subtitleCell
        if indexPath.row == 4 {
            identifier = MainStoryboard.TableViewCellIdentifiers.playAudioCell
        }else if indexPath.row == 6 {
            identifier = MainStoryboard.TableViewCellIdentifiers.reportAbuseCell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as UITableViewCell
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
            let playAudioCell = cell as! KSPlayAudioTableViewCell
            playAudioCell.titleLable.text = "About me"
            playAudioCell.subTitleLable.text = "about"
        case 5:
            cell.textLabel?.text = "User comments"
            cell.detailTextLabel?.text = person.comments
        case 6:
           break

        default:
           break
        }
        return cell
        
    }

    @IBAction func openMessage(sender: AnyObject) {
        let viewController = KSChattingViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func openPhone(sender: AnyObject) {
        let viewController = KSChattingViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    @IBAction func playAudio(sender: AnyObject) {

    }
    
}
