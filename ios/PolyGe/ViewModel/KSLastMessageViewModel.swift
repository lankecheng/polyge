//
//  KSLastMessageViewModel.swift
//  PolyGe
//
//  Created by king on 15/7/13.
//  Copyright © 2015年 king. All rights reserved.
//

import UIKit
import CoreStore
class KSLastMessageViewModel: KSCoreDataViewModel<LastMessage> {
    
    init(tableView: UITableView) {
        let monitor = CoreStore.monitorList(
            From(LastMessage),
            OrderBy(.Descending("createDate"))
        )
        super.init(tableView: tableView, monitor: monitor)
    }
}
