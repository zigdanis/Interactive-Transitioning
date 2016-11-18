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
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animationController
    }
    
}

class AnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration:TimeInterval = 1.0
    var propertyAnimator: UIViewPropertyAnimator?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting(transition: transitionContext) {
            propertyAnimator = propertyAnimatorForPresenting(using: transitionContext)
        } else {
            propertyAnimator = propertyAnimatorForDismissing(using: transitionContext)
        }
        propertyAnimator?.startAnimation()
    }
    
    private func propertyAnimatorForPresenting(using transitionContext: UIViewControllerContextTransitioning) -> UIViewPropertyAnimator? {

        //Prepare superview
        let fromVC = transitionContext.viewController(forKey: .from) as? ThumbImageViewController
        guard let originalRoundedView = fromVC?.thumbImageView  else { return nil }
        let toView = transitionContext.view(forKey: .to)!
        let containerView = transitionContext.containerView
        containerView.addSubview(toView)
        toView.isHidden = true
        originalRoundedView.isHidden = true
        
        //Setup animatable view
        let expandingMultiplier = 1/20.0
        let copyRoundedView = RoundedImageView(image: originalRoundedView.image)
        copyRoundedView.expandingMultiplier = expandingMultiplier
        copyRoundedView.frame = originalRoundedView.frame
        containerView.addSubview(copyRoundedView)
        setupViewFullScreenConstraints(roundedView: copyRoundedView)
        let initialRect = originalRoundedView.bounds
        let destinationRect = toView.bounds
        
        // Create animator
        let totalDuration = duration + duration * expandingMultiplier
        let timing = UICubicTimingParameters(animationCurve: .linear)
        let animator = UIViewPropertyAnimator(duration: totalDuration, timingParameters: timing)
        let relativeStart = duration/totalDuration
        animator.addAnimations {
            UIView.animateKeyframes(withDuration: totalDuration, delay: 0, options: [.calculationModeLinear], animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: relativeStart, animations: {
                    containerView.layoutIfNeeded()
                })
            })
            copyRoundedView.animateImageViewWith(action: .Expand, initial: initialRect, destination: destinationRect, duration: self.duration, options: [.curveLinear])
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
        //Prepare superview
        let fromNVC = transitionContext.viewController(forKey: .from) as? UINavigationController
        let fromVC = fromNVC?.viewControllers.first as? FullImageViewController
        let toVC = transitionContext.viewController(forKey: .to) as? ThumbImageViewController
        guard let originalFullView = fromVC?.fullImageView  else { return nil }
        guard let originalRoundedView = toVC?.thumbImageView else { return nil }
        let fromView = transitionContext.view(forKey: .from)!
        let containerView = transitionContext.containerView
        originalFullView.isHidden = true
        originalRoundedView.isHidden = true
        
        //Setup animatable view
        let expandingMultiplier = 1/20.0
        let copyRoundedView = RoundedImageView(image: originalFullView.image)
        copyRoundedView.expandingMultiplier = expandingMultiplier
        copyRoundedView.frame = originalFullView.frame
        containerView.addSubview(copyRoundedView)
        alignConstraints(toView: copyRoundedView, fromView: originalRoundedView)
        let initialRect = originalFullView.bounds
        let destinationRect = originalRoundedView.bounds
        
        // Create animator
        let totalDuration = duration + duration * expandingMultiplier
        let timing = UICubicTimingParameters(animationCurve: .linear)
        let animator = UIViewPropertyAnimator(duration: totalDuration, timingParameters: timing)
        let relativeDuration  = duration/totalDuration
        let relativeStart = 1 - relativeDuration
        animator.addAnimations {
            UIView.animateKeyframes(withDuration: totalDuration, delay: 0, options: [.calculationModeLinear], animations: {
                UIView.addKeyframe(withRelativeStartTime: relativeStart, relativeDuration: relativeDuration, animations: {
                    containerView.layoutIfNeeded()
                })
            })
            copyRoundedView.animateImageViewWith(action: .Collapse, initial: initialRect, destination: destinationRect, duration: self.duration, options: [.curveLinear])
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
}
