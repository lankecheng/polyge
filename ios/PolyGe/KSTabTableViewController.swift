//
//  KSTabTableViewController.swift
//  PolyGe
//
//  Created by king on 15/4/18.
//  Copyright (c) 2015年 king. All rights reserved.
//

import UIKit

class KSTabTableViewController: KSTableViewController {
    var firstTabTitle = NSLocalizedString("Professional", comment: "")
    var secondTabTitle = NSLocalizedString("Partner", comment: "")
    
    var personType  = PersonType.Professional
    private let firstTab = KSButton(frame: CGRectMake(0, 0, 120, 30))
    private let secondTab = KSButton(frame: CGRectMake(120, 0, 120, 30))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let titleView = UIView(frame: CGRectMake(0, 0, 240, 30))
        firstTab.setTitle(firstTabTitle, forState: UIControlState.Normal)
        firstTab.addTarget(self, action: "touchFirstTab:", forControlEvents: UIControlEvents.TouchUpInside)
        
        titleView.addSubview(firstTab)
        
        secondTab.setTitle(secondTabTitle, forState: UIControlState.Normal)
        secondTab.addTarget(self, action: "touchSecondTab:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        titleView.addSubview(secondTab)
        titleView.layer.cornerRadius = 4
        titleView.layer.borderWidth = 1
        titleView.layer.borderColor = UIColor.whiteColor().CGColor
        titleView.clipsToBounds = true
        navigationItem.titleView = titleView
        firstTab.selected = true
        firstTab.userInteractionEnabled = false
    }
    func touchFirstTab(sender: UIControl) {
        firstTab.selected = true
        firstTab.userInteractionEnabled = false
        secondTab.selected = false
        secondTab.userInteractionEnabled = true
        personType = PersonType.Professional
        tableView.reloadData()
    }
    func touchSecondTab(sender: UIControl) {
        firstTab.selected = false
        firstTab.userInteractionEnabled = true
        secondTab.selected = true
        secondTab.userInteractionEnabled = false
        personType = PersonType.Partner
        tableView.reloadData()
    }
    
}
