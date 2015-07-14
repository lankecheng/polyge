//
//  KSPersonViewController.swift
//  PolyGe
//
//  Created by king on 15/4/17.
//  Copyright (c) 2015年 king. All rights reserved.
//

import UIKit

class KSPersonViewController: KSTableViewController {
    var person: User?
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
    
    
    //MARK: UITableViewDataSource

    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            return 44
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var identifier = KSStoryboard.TableViewCellIdentifiers.subtitleCell
        if indexPath.row == 4 {
            identifier = KSStoryboard.TableViewCellIdentifiers.playAudioCell
        }else if indexPath.row == 5 {
            identifier = KSStoryboard.TableViewCellIdentifiers.reportOrSwitchCell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as UITableViewCell
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Native language"
            cell.detailTextLabel?.text = person!.language
        case 1:
            cell.textLabel?.text = "Country"
            cell.detailTextLabel?.text = person!.country
        case 2:
            cell.textLabel?.text = "Occupation"
            cell.detailTextLabel?.text = person!.occupation
        case 3:
            cell.textLabel?.text = "Hobbies & interests"
            cell.detailTextLabel?.text = person!.interest
        case 4:
            let playAudioCell = cell as! KSPlayAudioTableViewCell
            playAudioCell.titleLable.text = "About me"
            playAudioCell.subTitleLable.text = person!.about
        case 5:
            let reportOrSwitchCell = cell as! KSReportOrSwitchTableViewCell
            if person!.uid == NSUserDefaults.userID {
                reportOrSwitchCell.button.setTitle(KSLocalizedString("Switch Account"), forState: .Normal)
            }else{
                 reportOrSwitchCell.button.setTitle(KSLocalizedString("Report Account"), forState: .Normal)
            }

           break

        default:
           break
        }
        return cell
        
    }

    @IBAction func openMessage(sender: AnyObject) {
        let viewController = ChattingViewController()
        viewController.receiveUserID = person!.uid
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func openPhone(sender: AnyObject) {
        let viewController = ChattingViewController()
        viewController.receiveUserID = person!.uid
        navigationController?.pushViewController(viewController, animated: true)
    }
    @IBAction func playAudio(sender: AnyObject) {

    }
    @IBAction func reportOrSwitchAccout(sender: AnyObject) {
        if person!.uid == NSUserDefaults.userID {
            navigationController?.pushViewController(KSStoryboard.loginViewController, animated: true)
        }
    }
}
