//
//  KSPersonListTableViewCell.swift
//  PolyGe
//
//  Created by king on 15/4/17.
//  Copyright (c) 2015年 king. All rights reserved.
//

import UIKit

class KSPersonListTableViewCell: UITableViewCell {

    @IBOutlet weak var userNameLable: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var interestLable: UILabel!
    @IBOutlet weak var timeLable: UILabel!



    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
