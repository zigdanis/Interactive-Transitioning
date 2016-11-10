//
//  RoundedView.swift
//  InteractiveTransitioning
//
//  Created by Danis Ziganshin on 24/07/16.
//  Copyright © 2016 Zigdanis. All rights reserved.
//

import UIKit

@IBDesignable
public class RoundedImageView: UIImageView {
    let maskLayer = CAShapeLayer()
    let borderCircle = CAShapeLayer()
    var updatedRect: CGRect? = nil
    
    
    convenience init() {
        self.init(image: nil)
    }
    
    override convenience init(frame: CGRect) {
        self.init(image: UIImage(named: "close-winter"))
    }
    
    public override init(image: UIImage?) {
        super.init(image: image)
        setupViewBehaviour()
        addRoundingLayers()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder:coder)
        setupViewBehaviour()
        addRoundingLayers()
    }
    
    func setupViewBehaviour() {
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleAspectFill
    }
    
    override public func layoutSubviews() {
        updateRoundedLayers(for: updatedRect)
        super.layoutSubviews()
    }
    
    public override func prepareForInterfaceBuilder() {
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
    
    func updateRoundedLayers(for rect: CGRect? = nil) {
        let aBounds = rect ?? bounds
        let minSide = min(aBounds.width, aBounds.height)
        let x = aBounds.midX - minSide/2
        let y = aBounds.midY - minSide/2
        let squareInCenter = CGRect(x: x, y: y, width: minSide, height: minSide)
        borderCircle.frame = squareInCenter
        borderCircle.cornerRadius = minSide / 2
        
        let arcPath = CGPath(ellipseIn: squareInCenter, transform: nil)
        maskLayer.path = arcPath
        maskLayer.frame = aBounds
    }
    
    //MARK: - Public
    
    public func animateFrameAndPathOfImageView(initial: CGRect, destination: CGRect, duration: TimeInterval, options: UIViewAnimationOptions = []) {
        let minInitialSide = min(initial.width, initial.height)
        let minDestinationSide = min(destination.width, destination.height)
        let squareInitial = CGRect(x: 0, y: 0, width: minInitialSide, height: minInitialSide)
        let squareDestination = CGRect(x: 0, y: 0, width: minDestinationSide, height: minDestinationSide)
        
        let boundsAnimation = CABasicAnimation(keyPath: "bounds")
        boundsAnimation.fromValue = NSValue(cgRect: squareInitial)
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
        pathAnimation.fromValue = CGPath(ellipseIn: squareInitial, transform: nil)
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
    
    
    
    
    public func animateFrameAndPathOfImageViewBackAndForth(initial: CGRect, destination: CGRect, duration: TimeInterval, options: UIViewAnimationOptions = []) {
        let minInitialSide = min(initial.width, initial.height)
        let minDestinationSide = min(destination.width, destination.height)
        let squareInitial = CGRect(x: 0, y: 0, width: minInitialSide, height: minInitialSide)
        let squareDestination = CGRect(x: 0, y: 0, width: minDestinationSide, height: minDestinationSide)
        let half: NSNumber = 0.5
        
        let boundsAnimation = CAKeyframeAnimation(keyPath: "bounds")
        let boundsAnimationFromValue = NSValue(cgRect: squareInitial)
        let boundsAnimationToValue = NSValue(cgRect: squareDestination)
        boundsAnimation.values = [ boundsAnimationFromValue,
                                   boundsAnimationToValue,
                                   boundsAnimationFromValue ]
//        boundsAnimation.keyTimes = [half, half]
        boundsAnimation.timingFunctions = [
            CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear),
            CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear) ]
        boundsAnimation.duration = duration
        
        let positionAnimation = CAKeyframeAnimation(keyPath: "position")
        let fromPosition = CGPoint(x: initial.midX, y: initial.midY)
        let toPosition = CGPoint(x: destination.midX, y: destination.midY)
        positionAnimation.values = [ NSValue(cgPoint: fromPosition),
                                     NSValue(cgPoint: toPosition),
                                     NSValue(cgPoint: fromPosition) ]
//        positionAnimation.keyTimes = [half, half]
        positionAnimation.timingFunctions = [
            CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear),
            CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear) ]
        positionAnimation.duration = duration
        
        let cornersAnimation = CAKeyframeAnimation(keyPath: "cornerRadius")
        cornersAnimation.values = [ minInitialSide / 2,
                                    minDestinationSide / 2,
                                    minInitialSide / 2 ]
//        cornersAnimation.keyTimes = [half, half]
        cornersAnimation.timingFunctions = [
            CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear),
            CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear) ]
        cornersAnimation.duration = duration
        
        let pathAnimation = CAKeyframeAnimation(keyPath: "path")
        let fromPath = CGPath(ellipseIn: squareInitial, transform: nil)
        let toPath = CGPath(ellipseIn: squareDestination, transform: nil)
        pathAnimation.values = [ fromPath,
                                 toPath,
                                 fromPath ]
//        pathAnimation.keyTimes = [half, half]
        pathAnimation.timingFunctions = [
            CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear),
            CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear) ]
        pathAnimation.duration = duration
        
        let borderGroup = CAAnimationGroup()
        borderGroup.duration = duration
        borderGroup.animations = [boundsAnimation, positionAnimation, cornersAnimation]
        setupOptionsForAnimation(animation: borderGroup, options: options)
        
        let maskGroup = CAAnimationGroup()
        maskGroup.duration = duration
        maskGroup.animations = [boundsAnimation, positionAnimation, pathAnimation]
        setupOptionsForAnimation(animation: maskGroup, options: options)
        
//        borderCircle.cornerRadius = minDestinationSide / 2
        borderCircle.add(borderGroup, forKey: "Resizing border")
//        maskLayer.path = toPath
//        maskLayer.bounds = squareDestination
//        maskLayer.position = toPosition
        maskLayer.add(maskGroup, forKey: "Resizing circle mask")
    }
}
