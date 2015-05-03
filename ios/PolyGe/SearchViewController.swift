//
//  SecondViewController.swift
//  PolyGe
//
//  Created by king on 15/4/16.
//  Copyright (c) 2015年 king. All rights reserved.
//

import UIKit

class SearchViewController: KSTabTableViewController{
    let pickerView = KSPickerView(frame: CGRectMake(0, 0, ScreenBounds.width, 180))
    let conditions: [NSMutableArray] = [["language"," "],["Topic"," "],["Seats"," "],["Price"," "]]
    var pickerContent = [String]()
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = pickerView
        pickerView.hidden = true
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //MARK: UITableViewDataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if personType == .Professional{
            return conditions.count+1
        }else {
            return conditions.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (personType == .Professional && indexPath.row == conditions.count) || (personType == .Partner && indexPath.row == conditions.count-1 ) {
            return tableView.dequeueReusableCellWithIdentifier(MainStoryboard.TableViewCellIdentifiers.searchCell, forIndexPath: indexPath) as! UITableViewCell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(MainStoryboard.TableViewCellIdentifiers.subtitleCell, forIndexPath: indexPath) as! UITableViewCell
            cell.textLabel?.text = conditions[indexPath.row][0] as? String
            cell.detailTextLabel?.text = conditions[indexPath.row][1] as? String
            cell.layoutIfNeeded()
            return cell
        }
    }
    //MARK: UITableViewDelegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            pickerContent = ["English","Chinese"]
        case 1:
            pickerContent = ["运动","美食","游戏"]
        case 2:
            pickerContent = ["1","2","3-5","5以上"]
        case 3:
            pickerContent = ["0-5","6-10","11-15","16-20","20以上"]
        default:
            break
        }
        pickerView.pickerData = pickerContent
        pickerView.callBackBlock = {
            index in
            self.conditions[indexPath.row][1] = self.pickerContent[index]
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
            tableView.scrollEnabled = true

        }
        pickerView.hidden = false
        tableView.scrollEnabled = false
    }
}

