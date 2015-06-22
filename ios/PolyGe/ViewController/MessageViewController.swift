//
//  MessageViewController.swift
//  PolyGe
//
//  Created by king on 15/4/16.
//  Copyright (c) 2015年 king. All rights reserved.
//

import UIKit

class MessageViewController: KSTabTableViewController {

    override func viewDidLoad() {
        firstTabTitle = NSLocalizedString("Friends", comment: "")
        secondTabTitle = NSLocalizedString("Notes", comment: "")
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: UITableViewDataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  12
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier(MainStoryboard.TableViewCellIdentifiers.lastMessageCell, forIndexPath: indexPath) as UITableViewCell
    }

    

}
