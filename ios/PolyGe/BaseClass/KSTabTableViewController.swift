//
//  KSTabTableViewController.swift
//  PolyGe
//
//  Created by king on 15/4/18.
//  Copyright (c) 2015年 king. All rights reserved.
//

import UIKit

class KSTabTableViewController: KSTableViewController {
    var firstTabTitle = KSLocalizedString("Professional")
    var secondTabTitle = KSLocalizedString("Partner")
    var personType  = PersonType.Professional
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let segment = UISegmentedControl(items: [firstTabTitle,secondTabTitle])
        segment.addTarget(self, action: "segmentChanged:", forControlEvents:.ValueChanged)
        segment.selectedSegmentIndex = 0
        navigationItem.titleView = segment
    }
    func segmentChanged(segment: UISegmentedControl){
        if segment.selectedSegmentIndex == 0 {
            personType = .Professional
        }else {
            personType = .Partner
        }
        tableView.reloadData()
    }
}
