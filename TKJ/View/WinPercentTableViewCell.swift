//
//  WinPercentTableViewCell.swift
//  TKJ
//
//  Created by TakaoAtsushi on 2018/06/10.
//  Copyright © 2018年 TakaoAtsushi. All rights reserved.
//

import UIKit

class WinPercentTableViewCell: UITableViewCell {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
