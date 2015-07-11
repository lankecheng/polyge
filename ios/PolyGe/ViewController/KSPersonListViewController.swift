//
//  KSPersonListViewController.swift
//  PolyGe
//
//  Created by king on 15/4/16.
//  Copyright (c) 2015年 king. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import CoreStore
import ObjectMapper
class KSPersonListViewController: KSTableViewController {
    var personList: [User] = []
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        Alamofire.request(.GET, URLString: NSUserDefaults.host+"/show_teachers", parameters: ["token":NSUserDefaults.token] ).responseSwiftyJSON ({ (_, _, json, _)  in
            CoreStore.beginSynchronous({ (transaction) -> Void in
                for objectJson in json["result"].arrayValue {
                    let user = transaction.create(Into<User>())
                    Mapper<User>().map(objectJson.object, toObject: user)
                    self.personList.append(user)
                }
                transaction.commit()
            })
            self.tableView.reloadData()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: UITableViewDataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCellWithIdentifier(KSStoryboard.TableViewCellIdentifiers.personCell, forIndexPath: indexPath) as! KSPersonListTableViewCell
        let user = personList[indexPath.row]
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
        let index = self.tableView.indexPathForCell(cell)
        let viewControll = segue.destinationViewController as! KSPersonViewController
        viewControll.person = self.personList[index!.row]
    }
}
