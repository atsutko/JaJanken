//
//  BackgroundKolodaAnimator.swift
//  TKJ
//
//  Created by TakaoAtsushi on 2018/06/28.
//  Copyright © 2018年 TakaoAtsushi. All rights reserved.
//

import UIKit
import Koloda
import Pop

class BackgroundKolodaAnimator: KolodaViewAnimator {

    override func applyScaleAnimation(_ card: DraggableCardView, scale: CGSize, frame: CGRect, duration: TimeInterval, completion: AnimationCompletionBlock) {
        
        let scaleAnimation = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleAnimation?.springBounciness = 9
        scaleAnimation?.springSpeed = 16
        scaleAnimation?.toValue = NSValue(cgSize: scale)
        card.layer.pop_add(scaleAnimation, forKey: "scaleAnimation")
        
        let frameAnimation = POPSpringAnimation(propertyNamed: kPOPViewFrame)
        frameAnimation?.springBounciness = 9
        frameAnimation?.springSpeed = 16
        frameAnimation?.toValue = NSValue(cgRect: frame)
        if let completion = completion {
            frameAnimation?.completionBlock = { _, finished in
                completion(finished)
            }
        }
        card.pop_add(frameAnimation, forKey: "frameAnimation")
    }
    
}
