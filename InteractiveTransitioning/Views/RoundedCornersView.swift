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
        setupView()
        setupImageView()
        roundCorners()
    }
    
    required public init?(coder: NSCoder) {
        self.imageView = UIImageView(image: UIImage(named: "close-winter"))
        super.init(coder:coder)
        addSubview(imageView)
        setupView()
        setupImageView()
        roundCorners()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        roundCorners()
    }
    
    func setupView() {
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.clear
    }
    
    func setupImageView() {
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2
        
        let aspectRationConstraint = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: imageView, attribute: .height, multiplier: 1, constant: 0)
        var constraints = [ imageView.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor),
                            imageView.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor),
                            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
                            imageView.centerYAnchor.constraint(equalTo: centerYAnchor) ]
        for c in constraints {
            c.priority = 900
        }
        constraints += [aspectRationConstraint]
        NSLayoutConstraint.activate(constraints)

    }
    
    //MARK: public
    
    public func roundCorners() {
        imageView.layer.cornerRadius = bounds.size.width / 2
    }
    
    public func animateFrameAndPathOfImageView(initial: CGRect, destination: CGRect, duration: TimeInterval, options: UIViewAnimationOptions = []) {
        
        let minInitialSide = min(initial.width, initial.height)
        let minDestinationSide = min(destination.width, destination.height)
        
        let cornersAnimation = CABasicAnimation(keyPath: "cornerRadius")
        cornersAnimation.fromValue = minInitialSide / 2
        cornersAnimation.toValue = minDestinationSide / 2
        cornersAnimation.duration = duration
        
        setupOptionsForAnimation(animation: cornersAnimation, options: options)
        
        imageView.layer.cornerRadius = minDestinationSide / 2
        imageView.layer.add(cornersAnimation, forKey: "Resizing circle corners")
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
