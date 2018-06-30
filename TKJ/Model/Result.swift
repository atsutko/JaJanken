//
//  Result.swift
//  TKJ
//
//  Created by TakaoAtsushi on 2018/06/26.
//  Copyright © 2018年 TakaoAtsushi. All rights reserved.
//

import UIKit

class Result: NSObject {
    var category: String
    var user: User
    var result: Int
    var opponent: User
    
    init(category: String, user: User, opponent: User, result: Int) {
        self.category = category
        self.user = user
        self.opponent = opponent
        self.result = result
    }

}
