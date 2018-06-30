//
//  WinPercent.swift
//  TKJ
//
//  Created by TakaoAtsushi on 2018/06/10.
//  Copyright © 2018年 TakaoAtsushi. All rights reserved.
//

import UIKit

class WinPercent: NSObject {
    var percent: Double
    var user: User!
    var category: String
    
    init(percent: Double, category: String) {
        self.percent = percent
        self.category = category
    }

}
