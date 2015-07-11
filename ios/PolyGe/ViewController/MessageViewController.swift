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
class MessageViewController: KSTabTableViewController,ListSectionObserver {

    var monitor: ListMonitor<LastMessage>?
    
    override func viewDidLoad() {
        firstTabTitle = KSLocalizedString("Friends")
        secondTabTitle = KSLocalizedString("Notes")
        super.viewDidLoad()
        self.setupDataSource()
    }
    
    //MARK: UITableViewDataSource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return monitor?.numberOfSections() ?? 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return monitor?.numberOfObjectsInSection(section) ?? 0
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell  = tableView.dequeueReusableCellWithIdentifier(KSStoryboard.TableViewCellIdentifiers.lastMessageCell, forIndexPath: indexPath) as! KSPersonListTableViewCell
        let curMessage = monitor![indexPath]
        let receiveUser = KSUserHelper.getUser(curMessage.userID)!
        cell.userNameLable.text = receiveUser.uname;
        //        cell.avatarImageView.image =
        cell.interestLable.text = curMessage.info
        return cell
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! KSPersonListTableViewCell
        let indexPath = self.tableView.indexPathForCell(cell)
        let viewControll = segue.destinationViewController as! ChattingViewController
        let curMessage = monitor![indexPath!]
        viewControll.receiveUserID = curMessage.userID
    }
    
    func setupDataSource(){
        monitor = CoreStore.monitorList(
            From(LastMessage),
            GroupBy(),
            OrderBy(.Ascending("createDate"))
        )
        monitor?.addObserver(self)
    }
    deinit {
        monitor?.removeObserver(self)
    }

    func listMonitorWillChange(monitor: ListMonitor<LastMessage>) {
        
        self.tableView.beginUpdates()
    }
    
    func listMonitorDidChange(monitor: ListMonitor<LastMessage>) {
        
        self.tableView.endUpdates()
    }
    // MARK: ListObjectObserver
    
    func listMonitor(monitor: ListMonitor<LastMessage>, didInsertObject object: LastMessage, toIndexPath indexPath: NSIndexPath) {
        
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    func listMonitor(monitor: ListMonitor<LastMessage>, didDeleteObject object: LastMessage, fromIndexPath indexPath: NSIndexPath) {
        
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    func listMonitor(monitor: ListMonitor<LastMessage>, didUpdateObject object: LastMessage, atIndexPath indexPath: NSIndexPath) {
        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
    }
    
    func listMonitor(monitor: ListMonitor<LastMessage>, didMoveObject object: LastMessage, fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        
        self.tableView.deleteRowsAtIndexPaths([fromIndexPath], withRowAnimation: .Automatic)
        self.tableView.insertRowsAtIndexPaths([toIndexPath], withRowAnimation: .Automatic)
    }
    func listMonitor(monitor: ListMonitor<LastMessage>, didInsertSection sectionInfo: NSFetchedResultsSectionInfo, toSectionIndex sectionIndex: Int) {
        
        self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
    }
    
    func listMonitor(monitor: ListMonitor<LastMessage>, didDeleteSection sectionInfo: NSFetchedResultsSectionInfo, fromSectionIndex sectionIndex: Int) {
        
        self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
    }
}

