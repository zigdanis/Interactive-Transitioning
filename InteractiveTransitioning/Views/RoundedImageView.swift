//
//  RoundedView.swift
//  InteractiveTransitioning
//
//  Created by Danis Ziganshin on 24/07/16.
//  Copyright © 2016 Zigdanis. All rights reserved.
//

import UIKit

class RoundedImageView: UIImageView, AnimatableCircle {
    var maskLayer = CAShapeLayer()
    
    override init(image: UIImage?) {
        super.init(image: image)
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleAspectFill
        addMaskLayer()
    }
    
    convenience init() {
        self.init(image: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder:coder)
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleAspectFill
        addMaskLayer()
    }
    
    override func layoutSubviews() {
        updateMaskLayer()
        super.layoutSubviews()
    }
    
    override func prepareForInterfaceBuilder() {
        updateMaskLayer()
        super.prepareForInterfaceBuilder()
    }
    
    //MARK: - Logic
    
    func updateMaskLayer() {
        let arcPath = CGPath(ellipseIn: bounds, transform: nil)
        maskLayer.path = arcPath
        maskLayer.frame = bounds
    }
    
    func addMaskLayer() {
        maskLayer.fillColor = UIColor.white.cgColor
        maskLayer.lineWidth = 0
        updateMaskLayer()
        layer.mask = maskLayer
    }
    
    //MARK: - Public
    
    func animateFrameAndPathOfImageView(initial: CGRect, destination: CGRect, duration: TimeInterval, options: UIViewAnimationOptions = []) {
        let minSide = min(destination.width, destination.height)
        let squareDestination = CGRect(x: 0, y: 0, width: minSide, height: minSide)
        
        let boundsAnimation = CABasicAnimation(keyPath: "bounds")
        boundsAnimation.fromValue = NSValue(cgRect: initial)
        boundsAnimation.toValue = NSValue(cgRect: squareDestination)
        
        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.fromValue = CGPath(ellipseIn: initial, transform: nil)
        let toPath = CGPath(ellipseIn: squareDestination, transform: nil)
        pathAnimation.toValue = toPath
        
        let positionAnimation = CABasicAnimation(keyPath: "position")
        let fromPosition = CGPoint(x: initial.midX, y: initial.midY)
        let toPosition = CGPoint(x: destination.midX, y: destination.midY)
        positionAnimation.fromValue = NSValue(cgPoint: fromPosition)
        positionAnimation.toValue = NSValue(cgPoint: toPosition)
        
        let group = CAAnimationGroup()
        group.duration = duration
        group.animations = [boundsAnimation, pathAnimation, positionAnimation]
        
        setupOptionsForAnimation(animation: group, options: options)
        
        maskLayer.path = toPath
        maskLayer.bounds = squareDestination
        maskLayer.position = toPosition
        maskLayer.add(group, forKey: "Resizing circle mask")
    }
    
    //MARK: - Helpers
    
    func setupOptionsForAnimation(animation: CAAnimationGroup, options: UIViewAnimationOptions) {
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
