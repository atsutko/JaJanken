//
//  Category.swift
//  TKJ
//
//  Created by TakaoAtsushi on 2018/06/10.
//  Copyright © 2018年 TakaoAtsushi. All rights reserved.
//

import UIKit

class Category: NSObject {
    var title: String
    var image: UIImage
    
    init(title: String, image: UIImage) {
        self.title = title
        self.image = image
    }

}
