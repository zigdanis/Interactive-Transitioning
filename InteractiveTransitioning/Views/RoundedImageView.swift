//
//  RoundedView.swift
//  InteractiveTransitioning
//
//  Created by Danis Ziganshin on 24/07/16.
//  Copyright © 2016 Zigdanis. All rights reserved.
//

import UIKit

enum ReSizeAction {
    case Expand
    case Collapse
}

@IBDesignable
class RoundedImageView: UIImageView, CAAnimationDelegate {
    private let maskLayer = CAShapeLayer()
    private let borderCircle = CAShapeLayer()
    var expandedRect: CGRect? = nil
    var animationCompletion: (()->())?
    var expandingMultiplier = 1/20.0
    
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
    
    override public func layoutSubviews() {
        updateRoundedLayers(for: expandedRect)
        super.layoutSubviews()
    }
    
    override func prepareForInterfaceBuilder() {
        updateRoundedLayers()
        super.prepareForInterfaceBuilder()
    }
    
    //MARK: - Logic
    
    private func addRoundingLayers() {
        borderCircle.borderColor = UIColor.white.cgColor
        borderCircle.borderWidth = 2
        layer.addSublayer(borderCircle)
        
        maskLayer.fillColor = UIColor.white.cgColor
        maskLayer.lineWidth = 0
        layer.mask = maskLayer
        
        updateRoundedLayers()
    }
    
    private func updateRoundedLayers(for rect: CGRect? = nil) {
        let aBounds = rect ?? bounds
        let minSide = min(aBounds.width, aBounds.height)
        let x = aBounds.midX - minSide/2
        let y = aBounds.midY - minSide/2
        let squareInCenter = CGRect(x: x, y: y, width: minSide, height: minSide)
        borderCircle.frame = squareInCenter
        borderCircle.cornerRadius = minSide / 2
        
        let arcPath = CGPath(ellipseIn: squareInCenter, transform: nil)
        maskLayer.path = arcPath
        maskLayer.bounds = aBounds
        maskLayer.position = CGPoint(x: aBounds.midX, y: aBounds.midY)
    }
    
    //MARK: - Public

    private func setup(animation: CAKeyframeAnimation, with options:UIViewAnimationOptions, duration: TimeInterval, action: ReSizeAction) {
        let timingFunc = mediaTimingFunction(for: options)
        let linear = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        let timingFunctions = action == .Expand ? [ timingFunc, linear] : [ linear, timingFunc]
        let fullDuration = duration + duration * expandingMultiplier
        let intermediate = action == .Expand ?
            NSNumber(value: duration / fullDuration) :
            NSNumber(value: 1 - duration / fullDuration)
        let keyTimes = [NSNumber(value: 0), intermediate, NSNumber(value: 1)]
        
        animation.timingFunctions = timingFunctions
        animation.keyTimes = keyTimes
        animation.duration = fullDuration
    }
    
    private func enableBoundsAnim(action: ReSizeAction, squareInitial: CGRect, squareDestination: CGRect, squareResized: CGRect) -> CAKeyframeAnimation {
        let boundsAnimation = CAKeyframeAnimation(keyPath: "bounds")
        let boundsAnimationFromValue = NSValue(cgRect: squareInitial)
        let boundsAnimationToValue = NSValue(cgRect: squareDestination)
        let boundsAnimationExValue = NSValue(cgRect: squareResized)
        if action == .Expand {
            boundsAnimation.values = [ boundsAnimationFromValue,
                                       boundsAnimationToValue,
                                       boundsAnimationExValue ]
        } else {
            boundsAnimation.values = [ boundsAnimationExValue,
                                       boundsAnimationFromValue,
                                       boundsAnimationToValue ]
        }
        maskLayer.bounds = action == .Expand ? squareResized : squareDestination // destination
        return boundsAnimation
    }
    
    private func enablePositionAnim(action: ReSizeAction, initial: CGRect, destination: CGRect, resized: CGRect) -> CAKeyframeAnimation {
        let positionAnimation = CAKeyframeAnimation(keyPath: "position")
        let fromPosition = CGPoint(x: initial.midX, y: initial.midY)
        let toPosition = CGPoint(x: destination.midX, y: destination.midY)
        let exPosition = CGPoint(x: resized.midX, y: resized.midY)
        if action == .Expand {
            positionAnimation.values = [ NSValue(cgPoint: fromPosition),
                                         NSValue(cgPoint: toPosition),
                                         NSValue(cgPoint: exPosition) ]
        } else {
            positionAnimation.values = [ NSValue(cgPoint: exPosition) ,
                                         NSValue(cgPoint: fromPosition),
                                         NSValue(cgPoint: toPosition) ]
        }
        maskLayer.position = toPosition
        return positionAnimation
    }
    
    private func enableCornersAnim(action: ReSizeAction, minInitialSide: CGFloat, minDestinationSide: CGFloat, minExpandedSide: CGFloat) -> CAKeyframeAnimation {
        let cornersAnimation = CAKeyframeAnimation(keyPath: "cornerRadius")
        if action == .Expand {
            cornersAnimation.values = [ minInitialSide / 2,
                                        minDestinationSide / 2,
                                        minExpandedSide / 2 ]
        } else {
            cornersAnimation.values = [ minExpandedSide / 2,
                                        minInitialSide / 2,
                                        minDestinationSide / 2 ]
        }
        borderCircle.cornerRadius = action == .Expand ? minExpandedSide / 2 : minDestinationSide / 2
        return cornersAnimation
    }
    
    private func enablePathAnim(action: ReSizeAction, squareInitial: CGRect, squareDestination: CGRect, squareResized: CGRect) -> CAKeyframeAnimation {
        let pathAnimation = CAKeyframeAnimation(keyPath: "path")
        let fromPath = CGPath(ellipseIn: squareInitial, transform: nil)
        let toPath = CGPath(ellipseIn: squareDestination, transform: nil)
        let exPath = CGPath(ellipseIn: squareResized, transform: nil)
        if action == .Expand {
            pathAnimation.values = [ fromPath,
                                     toPath,
                                     exPath ]
        } else {
            pathAnimation.values = [ exPath,
                                     fromPath,
                                     toPath ]
        }
        maskLayer.path = action == .Expand ? exPath : toPath
        return pathAnimation
    }
    
    func animateImageViewWith(action: ReSizeAction, initial: CGRect, destination: CGRect, duration: TimeInterval, options: UIViewAnimationOptions = []) {
        let minInitialSide = min(initial.width, initial.height)
        let minDestinationSide = min(destination.width, destination.height)
        let squareInitial = CGRect(x: 0, y: 0, width: minInitialSide, height: minInitialSide)
        let x = destination.midX - minDestinationSide/2
        let y = destination.midY - minDestinationSide/2
        let squareDestination = CGRect(x: x, y: y, width: minDestinationSide, height: minDestinationSide)
        let squareResized = containingCircleRect(for: action == .Expand ? destination : initial)
        let minExpandedSide = squareResized.size.width
        let fullDuration = duration + duration * expandingMultiplier
        
        let boundsAnimation = enableBoundsAnim(action: action, squareInitial: squareInitial, squareDestination: squareDestination, squareResized: squareResized)
        setup(animation: boundsAnimation, with: options, duration: duration, action: action)
        
        let positionAnimation = enablePositionAnim(action: action, initial: initial, destination: destination, resized: squareResized)
        setup(animation: positionAnimation, with: options, duration: duration, action: action)
        
        let cornersAnimation = enableCornersAnim(action: action, minInitialSide: minInitialSide, minDestinationSide: minDestinationSide, minExpandedSide: minExpandedSide)
        setup(animation: cornersAnimation, with: options, duration: duration, action: action)
        
        let pathAnimation = enablePathAnim(action: action, squareInitial: squareInitial, squareDestination: squareDestination, squareResized: squareResized)
        setup(animation: pathAnimation, with: options, duration: duration, action: action)
        
        let borderGroup = CAAnimationGroup()
        borderGroup.duration = fullDuration
        borderGroup.animations = [boundsAnimation, positionAnimation, cornersAnimation]
        
        let maskGroup = CAAnimationGroup()
        maskGroup.delegate = self
        maskGroup.duration = fullDuration
        maskGroup.animations = [boundsAnimation, positionAnimation, pathAnimation]
        
        borderCircle.add(borderGroup, forKey: "Resizing border")
        maskLayer.add(maskGroup, forKey: "Resizing circle mask")
        
        if action == .Expand {
            expandedRect = squareResized
        } else {
            expandedRect = nil
        }
    }
    
    //MARK: - CAAnimation Delegate
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        animationCompletion?()
    }
    
    //MARK: - Helpers
    
    private func setupOptionsForAnimation(animation: CAAnimationGroup, options: UIViewAnimationOptions) {
        animation.timingFunction = self.mediaTimingFunction(for: options)
        if options.contains(.autoreverse) {
            animation.autoreverses = true
        }
        if options.contains(.repeat) {
            animation.repeatCount = MAXFLOAT
        }
    }
    
    private func mediaTimingFunction(for options: UIViewAnimationOptions) -> CAMediaTimingFunction {
        var functionName = kCAMediaTimingFunctionLinear
        if options.contains(.curveLinear) {
            functionName = kCAMediaTimingFunctionLinear
        } else if options.contains(.curveEaseIn) {
            functionName = kCAMediaTimingFunctionEaseIn
        } else if options.contains(.curveEaseOut) {
            functionName = kCAMediaTimingFunctionEaseOut
        } else if options.contains(.curveEaseInOut) {
            functionName = kCAMediaTimingFunctionEaseInEaseOut
        }
        return CAMediaTimingFunction(name: functionName)
    }
    
    
    private func containingCircleRect(for rect: CGRect) -> CGRect {
        let height = rect.height
        let width = rect.width
        let diameter = sqrt((height * height) + (width * width))
        let newX = rect.origin.x - (diameter - width) / 2
        let newY = rect.origin.y - (diameter - height) / 2
        let containerRect = CGRect(x: newX, y: newY, width: diameter, height: diameter)
        return containerRect
    }
}
