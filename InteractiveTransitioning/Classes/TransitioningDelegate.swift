//
//  TransitioningDelegate.swift
//  InteractiveTransitioning
//
//  Created by Danis Ziganshin on 18/07/16.
//  Copyright © 2016 Zigdanis. All rights reserved.
//

import UIKit
import Foundation

class TransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    let animationController = AnimationController()
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animationController
    }
    
//    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return animationController
//    }
    
}

class AnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration:TimeInterval = 1
    var propertyAnimator: UIViewPropertyAnimator?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        //Prepare superview
        let fromVC = transitionContext.viewController(forKey: .from) as? ThumbImageViewController
        guard let originalRoundedView = fromVC?.thumbImageView  else { return }
        let toView = transitionContext.view(forKey: .to)!
        let containerView = transitionContext.containerView
        containerView.addSubview(toView)
        toView.isHidden = true
        originalRoundedView.isHidden = true
        
        //Setup animatable view
        let copyRoundedView = RoundedImageView(image: originalRoundedView.image)
        copyRoundedView.frame = originalRoundedView.frame
        containerView.addSubview(copyRoundedView)
        setupViewFullScreenConstraints(roundedView: copyRoundedView)
        let initialRect = originalRoundedView.bounds
        let destinationRect = toView.bounds
        
        // Animate
        let options: UIViewAnimationOptions = [.curveEaseInOut]
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            containerView.layoutIfNeeded()
        })
        copyRoundedView.animateImageViewWithExpand(initial: initialRect, destination: destinationRect, duration: duration, options: options)
        copyRoundedView.animationCompletion = {
            toView.isHidden = false
            originalRoundedView.isHidden = false
            copyRoundedView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
    
   
    func myAnimateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting(transition: transitionContext) {
            propertyAnimator = propertyAnimatorForPresenting(using: transitionContext)
        } else {
            propertyAnimator = propertyAnimatorForDismissing(using: transitionContext)
        }
        propertyAnimator?.startAnimation()
    }
    
    private func propertyAnimatorForPresenting(using transitionContext: UIViewControllerContextTransitioning) -> UIViewPropertyAnimator? {

        let fromVC = transitionContext.viewController(forKey: .from) as? ThumbImageViewController
        guard let originalRoundedView = fromVC?.thumbImageView  else { return nil }
        let toView = transitionContext.view(forKey: .to)!
        let containerView = transitionContext.containerView
        
        let copyRoundedView = RoundedImageView(image: originalRoundedView.image)
        copyRoundedView.frame = originalRoundedView.frame
        containerView.addSubview(toView)
        toView.isHidden = true
        containerView.addSubview(copyRoundedView)
        originalRoundedView.isHidden = true
        setupViewFullScreenConstraints(roundedView: copyRoundedView)
        
        let initialBounds = copyRoundedView.bounds
        let containigCircleRect = self.containingCircleRect(for: initialBounds)
        containerView.layoutIfNeeded()
        
        // Create animator
        let timing = UICubicTimingParameters(animationCurve: .easeInOut)
        let animator = UIViewPropertyAnimator(duration: duration, timingParameters: timing)
        animator.addAnimations {
            let options: UIViewAnimationOptions = []
            copyRoundedView.animateFrameAndPathOfImageView(initial: initialBounds, destination: containigCircleRect, duration: self.duration, options: options)
        }
        animator.addCompletion { (position) in
            toView.isHidden = false
            originalRoundedView.isHidden = false
            copyRoundedView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
        return animator
    }
    
    private func propertyAnimatorForDismissing(using transitionContext: UIViewControllerContextTransitioning) -> UIViewPropertyAnimator? {
        let fromNVC = transitionContext.viewController(forKey: .from) as? UINavigationController
        let fromVC = fromNVC?.viewControllers.first as? FullImageViewController
        let toVC = transitionContext.viewController(forKey: .to) as? ThumbImageViewController
        guard let originalFullView = fromVC?.fullImageView  else { return nil }
        guard let originalRoundedView = toVC?.thumbImageView else { return nil }
        let fromView = transitionContext.view(forKey: .from)!
        let containerView = transitionContext.containerView
        
        let copyRoundedView = RoundedImageView(image: originalFullView.image)
        copyRoundedView.frame = originalFullView.frame
        containerView.addSubview(copyRoundedView)
        originalFullView.isHidden = true
        originalRoundedView.isHidden = true
        alignConstraints(toView: copyRoundedView, fromView: originalRoundedView)
        
        // Create animator
        let timing = UICubicTimingParameters(animationCurve: .easeInOut)
        let animator = UIViewPropertyAnimator(duration: duration, timingParameters: timing)
        animator.addAnimations {
            UIView.animateKeyframes(withDuration: self.duration, delay: 0, options: [.calculationModeCubic], animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: self.duration/2.0) {
                    self.expandAnimation(forView: copyRoundedView)
                }
                UIView.addKeyframe(withRelativeStartTime: self.duration/2.0, relativeDuration: self.duration/2.0) {
                    let options: UIViewAnimationOptions = []
                    let destinationBounds = copyRoundedView.bounds
                    let height = destinationBounds.height
                    let diffSide = height - destinationBounds.width
                    let maxRect = CGRect(x: -diffSide/2, y: 0, width: height, height: height)
                    copyRoundedView.animateFrameAndPathOfImageView(initial: destinationBounds, destination: maxRect, duration: self.duration/2.0, options: options)
                }
            })
        }
        animator.addCompletion { (position) in
            copyRoundedView.removeFromSuperview()
            originalRoundedView.isHidden = false
            fromView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
        return animator
    }
    
    private func isPresenting(transition: UIViewControllerContextTransitioning) -> Bool {
        guard let toVC = transition.viewController(forKey: .from) else {
            return true
        }
        let isPresentingFull = toVC is ThumbImageViewController
        return isPresentingFull
    }
    
    private func expandAnimation(forView: RoundedImageView) {
        let options: UIViewAnimationOptions = []
        let initialBounds = forView.bounds
        forView.superview?.layoutIfNeeded()
        let destinationBounds = forView.bounds
        forView.animateFrameAndPathOfImageView(initial: initialBounds, destination: destinationBounds, duration: self.duration, options: options)
    }
    
    // MARK: - Constraints setup
    
    private func setupViewFullScreenConstraints(roundedView: UIView) {
        let views = ["roundedView": roundedView]
        let horizont = NSLayoutConstraint.constraints(withVisualFormat: "H:|[roundedView]|", options:.alignAllBottom, metrics: nil, views: views)
        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|[roundedView]|", options:.alignAllBottom, metrics: nil, views: views)
        let constraints = horizont + vertical
        NSLayoutConstraint.activate(constraints)
    }
    
    private func alignConstraints(toView: UIView, fromView: UIView) {
        let constraints = [ toView.topAnchor.constraint(equalTo: fromView.topAnchor),
                            toView.leadingAnchor.constraint(equalTo: fromView.leadingAnchor),
                            toView.trailingAnchor.constraint(equalTo: fromView.trailingAnchor),
                            toView.bottomAnchor.constraint(equalTo: fromView.bottomAnchor) ]
        NSLayoutConstraint.activate(constraints)
    }

    // MARK: - Helpers
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
