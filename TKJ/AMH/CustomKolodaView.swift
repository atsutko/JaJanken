//
//  CustomKolodaView.swift
//  TKJ
//
//  Created by TakaoAtsushi on 2018/06/28.
//  Copyright © 2018年 TakaoAtsushi. All rights reserved.
//

import UIKit
import Koloda

class CustomKolodaView: KolodaView {
    
    let defaultTopOffset: CGFloat = 20
    let defaultHorizontalOffset: CGFloat = 10
    let defaultHeightRatio: CGFloat = 1.25
    let backgroundCardHorizontalMarginMultiplier: CGFloat = 0.25
    let backgroundCardScalePercent: CGFloat = 1.5

    override func frameForCard(at index: Int) -> CGRect {
        if index == 0 {
            let topOffset: CGFloat = defaultTopOffset
            let xOffset: CGFloat = defaultHorizontalOffset
            let width = (self.frame).width - 2 * defaultHorizontalOffset
            let height = width * defaultHeightRatio
            let yOffset: CGFloat = topOffset
            let frame = CGRect(x: xOffset, y: yOffset, width: width, height: height)
            
            return frame
        } else if index == 1 {
            let horizontalMargin = -self.bounds.width * backgroundCardHorizontalMarginMultiplier
            let width = self.bounds.width * backgroundCardScalePercent
            let height = width * defaultHeightRatio
            return CGRect(x: horizontalMargin, y: 0, width: width, height: height)
        }
        return CGRect.zero
    }
   

}
