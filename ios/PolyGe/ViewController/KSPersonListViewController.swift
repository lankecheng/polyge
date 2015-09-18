//
//  KSPersonListViewController.swift
//  PolyGe
//
//  Created by king on 15/4/16.
//  Copyright (c) 2015年 king. All rights reserved.
//

import UIKit
import Alamofire
import CoreStore
import Kingfisher
class KSPersonListViewController: KSTableViewController {
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        Alamofire.request(.GET, NSUserDefaults.host+"/show_teachers", parameters: ["token":NSUserDefaults.token] ).responseSwiftyJSON ({ (_, _, result)  in
            let json = result.value!
            CoreStore.beginSynchronous({ (transaction) -> Void in
                
                var personList: [User] = []
                for objectJson in json["result"].arrayValue {
                    let user = transaction.create(Into<User>())
                    user.fromJSON(objectJson)
                    personList.append(user)
                }
                self.viewModel = KSArrayViewModel(dataSource: personList)
                transaction.commit()
            })
            self.tableView.reloadData()
        })
    }
    
    
    //MARK: UITableViewDataSource
  
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCellWithIdentifier(KSStoryboard.TableViewCellIdentifiers.personCell, forIndexPath: indexPath) as! KSPersonListTableViewCell
        let user =  self.viewModel![indexPath] as! User
        cell.userNameLable.text = user.uname
        cell.interestLable.text = KSLocalizedString("Topic: ") + (user.interest ?? "")
        if let avatar = user.avatar {
            cell.avatarImageView.kf_setImageWithURL(NSURL(string: avatar)!,placeholderImage:kUserPlaceHolderImage)
        }else{
            cell.avatarImageView.image = kUserPlaceHolderImage
        }
        return cell
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! KSPersonListTableViewCell
        let indexPath = self.tableView.indexPathForCell(cell)
        let viewControll = segue.destinationViewController as! KSPersonViewController
        viewControll.person = self.viewModel![indexPath!] as! User
    }
}
