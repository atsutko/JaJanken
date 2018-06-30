//
//  CustomOverlayView.swift
//  TKJ
//
//  Created by TakaoAtsushi on 2018/06/28.
//  Copyright © 2018年 TakaoAtsushi. All rights reserved.
//

import UIKit
import Koloda



class CustomOverlayView: OverlayView {
    
    private let overlayRightImageName = "overlay_like"
    private let overlayLeftImageName = "overlay_skip"
    
    @IBOutlet lazy var overlayImageView: UIImageView! = {
        [unowned self] in
        
        var imageView = UIImageView(frame: self.bounds)
        self.addSubview(imageView)
        
        return imageView
        }()
    
    override var overlayState: SwipeResultDirection?  {
        didSet {
            switch overlayState {
            case .left? :
                overlayImageView.image = UIImage(named: overlayLeftImageName)
            case .right? :
                overlayImageView.image = UIImage(named: overlayRightImageName)
            default:
                overlayImageView.image = nil
            }
            
        }
    }
    

    

}
