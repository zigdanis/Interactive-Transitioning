//
//  RoundedView.swift
//  InteractiveTransitioning
//
//  Created by Danis Ziganshin on 24/07/16.
//  Copyright © 2016 Zigdanis. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedImageView: UIImageView, AnimatableCircle {
    let maskLayer = CAShapeLayer()
    let borderCircle = CAShapeLayer()
    
    convenience init() {
        self.init(image: nil)
    }
    
    override convenience init(frame: CGRect) {
        self.init(image: UIImage(named: "close-winter"))
    }
    
    override init(image: UIImage?) {
        super.init(image: image)
        setupViewBehaviour()
        addRoundingLayers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder:coder)
        setupViewBehaviour()
        addRoundingLayers()
    }
    
    func setupViewBehaviour() {
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleAspectFill
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateRoundedLayers()
    }
    
    override func prepareForInterfaceBuilder() {
        updateRoundedLayers()
        super.prepareForInterfaceBuilder()
    }
    
    //MARK: - Logic
    
    func addRoundingLayers() {
        borderCircle.borderColor = UIColor.white.cgColor
        borderCircle.borderWidth = 2
        layer.addSublayer(borderCircle)
        
        maskLayer.fillColor = UIColor.white.cgColor
        maskLayer.lineWidth = 0
        layer.mask = maskLayer

        updateRoundedLayers()
    }
    
    func updateRoundedLayers() {
        borderCircle.frame = bounds
        borderCircle.cornerRadius = bounds.width / 2
        
        let arcPath = CGPath(ellipseIn: bounds, transform: nil)
        maskLayer.path = arcPath
        maskLayer.frame = bounds
    }
    
    //MARK: - Public
    
    func animateFrameAndPathOfImageView(initial: CGRect, destination: CGRect, duration: TimeInterval, options: UIViewAnimationOptions = []) {
        let minInitialSide = min(initial.width, initial.height)
        let minDestinationSide = min(destination.width, destination.height)
        let squareDestination = CGRect(x: 0, y: 0, width: minDestinationSide, height: minDestinationSide)
        
        let boundsAnimation = CABasicAnimation(keyPath: "bounds")
        boundsAnimation.fromValue = NSValue(cgRect: initial)
        boundsAnimation.toValue = NSValue(cgRect: squareDestination)
        
        let positionAnimation = CABasicAnimation(keyPath: "position")
        let fromPosition = CGPoint(x: initial.midX, y: initial.midY)
        let toPosition = CGPoint(x: destination.midX, y: destination.midY)
        positionAnimation.fromValue = NSValue(cgPoint: fromPosition)
        positionAnimation.toValue = NSValue(cgPoint: toPosition)
        
        let cornersAnimation = CABasicAnimation(keyPath: "cornerRadius")
        cornersAnimation.fromValue = minInitialSide / 2
        cornersAnimation.toValue = minDestinationSide / 2
        
        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.fromValue = CGPath(ellipseIn: initial, transform: nil)
        let toPath = CGPath(ellipseIn: squareDestination, transform: nil)
        pathAnimation.toValue = toPath
        
        let borderGroup = CAAnimationGroup()
        borderGroup.duration = duration
        borderGroup.animations = [boundsAnimation, positionAnimation, cornersAnimation]
        setupOptionsForAnimation(animation: borderGroup, options: options)
        
        let maskGroup = CAAnimationGroup()
        maskGroup.duration = duration
        maskGroup.animations = [boundsAnimation, positionAnimation, pathAnimation]
        setupOptionsForAnimation(animation: maskGroup, options: options)
        
        borderCircle.cornerRadius = minDestinationSide / 2
        borderCircle.add(borderGroup, forKey: "Resizing border")
        maskLayer.path = toPath
        maskLayer.bounds = squareDestination
        maskLayer.position = toPosition
        maskLayer.add(maskGroup, forKey: "Resizing circle mask")
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
