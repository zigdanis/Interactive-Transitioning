//
//  RoundedImageView.swift
//  InteractiveTransitioning
//
//  Created by Danis Ziganshin on 16/07/16.
//  Copyright © 2016 Zigdanis. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedImageView : UIImageView {
    @IBInspectable var borderColor: UIColor = UIColor.white()
    @IBInspectable var borderWidth: CGFloat = 1
    
    override func layoutSubviews() {
        updateLayer()
        super.layoutSubviews()
    }
    
    override func prepareForInterfaceBuilder() {
        updateLayer()
        super.prepareForInterfaceBuilder()
    }
    
    func updateLayer() {
        let minSide = min(bounds.size.width, bounds.size.height)
        layer.cornerRadius = ceil(minSide / 2)
        layer.masksToBounds = true
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        //layer.shouldRasterize = true
    }
}
