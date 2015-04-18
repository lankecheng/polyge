//
//  MeViewController.swift
//  PolyGe
//
//  Created by king on 15/4/16.
//  Copyright (c) 2015年 king. All rights reserved.
//

import UIKit

class MeViewController: KSTableViewController {
    var personStatu = PersonStatu.offLine
    var dataSource: [[[String:String]]] {
        get{
            if personStatu == .offLine {
                return [
                    [["image":"User","title":"Longin"],
                        ["image":"Settings","title":"Settings"]],
                    [["image":"How it works","title":"How it works"],
                        ["image":"Feedback","title":"Feedback"],
                        ["image":"Help","title":"Help"]]
                ]
            }else {
                return [
                    [["image":"User","title":"Longin"],
                        ["image":"Friends","title":"Friends"],
                        ["image":"Settings","title":"Settings"],
                        ["image":"Friends","title":"Friends"],
                        ["image":"Tracking","title":"Tracking"],
                        ["image":"Credit","title":"Credit"],
                        ["image":"Schedule","title":"Schedule"]],
                    [["image":"How it works","title":"How it works"],
                        ["image":"Feedback","title":"Feedback"],
                        ["image":"Help","title":"Help"]]
                ]
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: UITableViewDataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
         let cellIdentifier = "cellIdentifier"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as?UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
        }
        let data = dataSource[indexPath.section][indexPath.row]
        cell!.imageView?.image = UIImage(named: data["image"]!)
        cell!.textLabel?.text = data["title"]
        return cell!
    }
    


}
