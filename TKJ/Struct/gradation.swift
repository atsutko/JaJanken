//
//  gradation.swift
//  TKJ
//
//  Created by TakaoAtsushi on 2018/06/15.
//  Copyright © 2018年 TakaoAtsushi. All rights reserved.
//

import UIKit

class gradation: NSObject {

   
    static func gradation(view: UIView) {
    view.backgroundColor = UIColor.white
        
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = view.bounds
    
    let color1 = UIColor(red: 255/255, green:240/255, blue: 64/255, alpha: 1.0).cgColor
    let color2 = UIColor(red: 220/255, green:205/255, blue: 30/255, alpha: 1.0).cgColor
    
    gradientLayer.colors = [color1, color2]

    gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
    gradientLayer.endPoint = CGPoint.init(x: 0.5, y:0.5)
    
    view.layer.insertSublayer(gradientLayer,at:0)
    
    }
    
}
