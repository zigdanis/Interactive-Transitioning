//
//  RoundedView.swift
//  InteractiveTransitioning
//
//  Created by Danis Ziganshin on 24/07/16.
//  Copyright © 2016 Zigdanis. All rights reserved.
//

import UIKit

public class RoundedCornersView: UIImageView {
    
    override public init(image: UIImage?) {
        super.init(image: image)
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleAspectFill
        layer.borderColor = UIColor.white().cgColor
        layer.borderWidth = 2
        roundCorners()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder:coder)
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleAspectFill
        layer.borderColor = UIColor.white().cgColor
        layer.borderWidth = 2
        roundCorners()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        roundCorners()
    }
    
    //MARK: public
    
    public func roundCorners() {
        layer.cornerRadius = bounds.size.width / 2
    }
    
    public func animateFrameAndPathOfImageView(initial: CGRect, destination: CGRect, duration: TimeInterval, options: UIViewAnimationOptions = []) {
        
        let cornersAnimation = CABasicAnimation(keyPath: "cornerRadius")
        cornersAnimation.fromValue = initial.size.width / 2
        cornersAnimation.toValue = destination.size.width / 2
        cornersAnimation.duration = duration
        
        setupOptionsForAnimation(animation: cornersAnimation, options: options)
        
        layer.cornerRadius = destination.size.width / 2
        layer.add(cornersAnimation, forKey: "Resizing circle corners")
    }
    
    func setupOptionsForAnimation(animation: CAAnimation, options: UIViewAnimationOptions) {
        var functionName: String?
        if options.contains(.curveLinear) {
            functionName = kCAMediaTimingFunctionLinear
        } else if options.contains(.curveEaseIn) {
            functionName = kCAMediaTimingFunctionEaseIn
        } else if options.contains(.curveEaseOut) {
            functionName = kCAMediaTimingFunctionEaseOut
        } else if options.contains(.curveEaseInOut) {
            functionName = kCAMediaTimingFunctionEaseInEaseOut
        }
        
        if let functionName = functionName {
            animation.timingFunction = CAMediaTimingFunction(name: functionName)
        }
        if options.contains(.autoreverse) {
            animation.autoreverses = true
        }
        if options.contains(.repeat) {
            animation.repeatCount = MAXFLOAT
        }
    }
}
