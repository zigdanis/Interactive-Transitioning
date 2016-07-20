//
//  RoundedImageView2.swift
//  InteractiveTransitioning
//
//  Created by Danis Ziganshin on 20/07/16.
//  Copyright © 2016 Zigdanis. All rights reserved.
//

import UIKit

class RoundedImageView2: UIImageView {
    
    var maskLayer: CAShapeLayer!
    
    func applyRoundedMask() {
        maskLayer = CAShapeLayer()
        maskLayer.fillColor = UIColor.black().cgColor
        maskLayer.strokeColor = UIColor.black().cgColor
        let arcPath = CGPath(ellipseIn: bounds, transform: nil)
        maskLayer.path = arcPath
        layer.mask = maskLayer
        layer.mask!.frame = layer.bounds
    }
    
    func updateMaskLayerRadius() {
        let arcPath = CGPath(ellipseIn: bounds, transform: nil)
        maskLayer.path = arcPath
        maskLayer.frame = layer.bounds
    }
}
