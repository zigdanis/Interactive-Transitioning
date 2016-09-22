//
//  RoundedView.swift
//  InteractiveTransitioning
//
//  Created by Danis Ziganshin on 24/07/16.
//  Copyright © 2016 Zigdanis. All rights reserved.
//

import UIKit

public class RoundedCornersView: UIView, AnimatableCircle {
    
    let imageView: UIImageView
    var image: UIImage? {
        get {
            return imageView.image
        }
    }
    
    public init(image: UIImage?) {
        imageView = UIImageView(image: image)
        super.init(frame: CGRect.zero)
        addSubview(imageView)
        translatesAutoresizingMaskIntoConstraints = false
        setupImageView()
        roundCorners()
    }
    
    required public init?(coder: NSCoder) {
        self.imageView = UIImageView(image: nil)
        super.init(coder:coder)
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleAspectFill
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 2
        roundCorners()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        roundCorners()
    }
    
    func setupImageView() {
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2
        
        let views = ["imageView": imageView]
        let horizont = NSLayoutConstraint.constraints(withVisualFormat: "H:|[imageView]|@20", options:.alignAllBottom, metrics: nil, views: views)
        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|[imageView]|@20", options:.alignAllBottom, metrics: nil, views: views)
        let constraints = horizont + vertical
        NSLayoutConstraint.activate(constraints)
    }
    
    //MARK: public
    
    public func roundCorners() {
        imageView.layer.cornerRadius = bounds.size.width / 2
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
