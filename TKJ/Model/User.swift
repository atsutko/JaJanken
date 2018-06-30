//
//  User.swift
//  TKJ
//
//  Created by TakaoAtsushi on 2018/06/10.
//  Copyright © 2018年 TakaoAtsushi. All rights reserved.
//

import UIKit

class User: NSObject {
    var userName: String
    var email: String
    var userID: String!
    var image: UIImage!
    
    init(userName: String, email: String) {
        self.userName = userName
        self.email = email
    }

}
