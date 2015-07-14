//
//  MessageViewController.swift
//  PolyGe
//
//  Created by king on 15/4/16.
//  Copyright (c) 2015年 king. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreStore
class MessageViewController: KSTabTableViewController {
    
    override func viewDidLoad() {
        firstTabTitle = KSLocalizedString("Friends")
        secondTabTitle = KSLocalizedString("Notes")
        super.viewDidLoad()
        self.viewModel = KSLastMessageViewModel(tableView: self.tableView)
    }
    
    //MARK: UITableViewDataSource
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell  = tableView.dequeueReusableCellWithIdentifier(KSStoryboard.TableViewCellIdentifiers.lastMessageCell, forIndexPath: indexPath) as! KSPersonListTableViewCell
        let curMessage = self.viewModel![indexPath] as! LastMessage
        let receiveUser = KSUserHelper.getUser(curMessage.userID)!
        cell.userNameLable.text = receiveUser.uname;
//                cell.avatarImageView.image =
        cell.interestLable.text = curMessage.info
        cell.timeLable.text = curMessage.createDate.relativeTimeToString()
        return cell
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! KSPersonListTableViewCell
        let indexPath = self.tableView.indexPathForCell(cell)
        let viewControll = segue.destinationViewController as! ChattingViewController
        let curMessage = self.viewModel![indexPath!] as! LastMessage
        viewControll.receiveUserID = curMessage.userID
    }
}

