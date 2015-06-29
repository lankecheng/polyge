//
//  FirstViewController.swift
//  PolyGe
//
//  Created by king on 15/4/16.
//  Copyright (c) 2015年 king. All rights reserved.
//

import UIKit

class HomeViewController: KSTabTableViewController {
    let languages = ["English","Chinese"]
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //MARK: UITableViewDataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCellWithIdentifier(KSStoryboard.TableViewCellIdentifiers.languageCell, forIndexPath: indexPath) as! KSLanguageTableViewCell
        cell.label.text = KSLocalizedString(languages[indexPath.row])
        cell.languageImage.image = UIImage(named: languages[indexPath.row])
        return cell
    }
}

