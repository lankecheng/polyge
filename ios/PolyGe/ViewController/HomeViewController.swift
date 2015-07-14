//
//  FirstViewController.swift
//  PolyGe
//
//  Created by king on 15/4/16.
//  Copyright (c) 2015年 king. All rights reserved.
//

import UIKit

class HomeViewController: KSTabTableViewController {
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = KSArrayViewModel(dataSource: ["English","Chinese"])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //MARK: UITableViewDataSource
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCellWithIdentifier(KSStoryboard.TableViewCellIdentifiers.languageCell, forIndexPath: indexPath) as! KSLanguageTableViewCell
        let str = self.viewModel![indexPath] as! String
        cell.label.text = KSLocalizedString(str)
        cell.languageImage.image = UIImage(named: str)
        return cell
    }
}
