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
}

class AnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration:TimeInterval = 1
    
    var propertyAnimator: UIViewPropertyAnimator?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        propertyAnimator = propertyAnimator(using: transitionContext)
        propertyAnimator?.startAnimation()
    }
    
    func propertyAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewPropertyAnimator? {
        let inView = transitionContext.containerView
        guard let toNavVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? UINavigationController else {
            return nil
        }
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? FirstViewController else {
            return nil
        }
        guard let secondVC = toNavVC.viewControllers.first as? SecondViewController else {
            return nil
        }
        let fromIV = fromVC.thumbImageView!
        let toView = toNavVC.view!
        
        //Setup
        inView.addSubview(toView)
        toNavVC.navigationBar.alpha = 0
        secondVC.view.alpha = 0
        
        let animatableCopy = RoundedImageView(image: fromIV.image)
        inView.addSubview(animatableCopy)
        fromIV.isHidden = true
        
        let completion = {
            animatableCopy.removeFromSuperview()
            secondVC.view.alpha = 1
            fromIV.isHidden = false
            transitionContext.completeTransition(true)
        }
        
        let timing = UICubicTimingParameters(animationCurve: .easeInOut)
        let animator = UIViewPropertyAnimator(duration: duration, timingParameters: timing)
        
        animateRoundedView(roundedView: animatableCopy, fromOriginal:fromIV)
        animator.addAnimations {
            self.expandAnimation(forView: animatableCopy)
        }
        animator.addCompletion { (position) in
            completion()
        }
        return animator
    }
    
    func animateRoundedView<T:UIView>(roundedView: T, fromOriginal: UIView) where T:AnimatableCircle {
        let constraints = alignConstraints(toView: roundedView, fromView: fromOriginal)
        roundedView.superview?.layoutIfNeeded()
        NSLayoutConstraint.deactivate(constraints)
        
        activateFullScreenConstraints(forView: roundedView)
    }
    
    func alignConstraints(toView: UIView, fromView: UIView) -> [NSLayoutConstraint] {
        let constraints = [ toView.topAnchor.constraint(equalTo: fromView.topAnchor),
                            toView.leadingAnchor.constraint(equalTo: fromView.leadingAnchor),
                            toView.trailingAnchor.constraint(equalTo: fromView.trailingAnchor),
                            toView.bottomAnchor.constraint(equalTo: fromView.bottomAnchor) ]
        NSLayoutConstraint.activate(constraints)
        return constraints
    }
    
    func activateFullScreenConstraints(forView: UIView) {
        let views = ["roundedView": forView]
        let horizont = NSLayoutConstraint.constraints(withVisualFormat: "H:|[roundedView]|", options:.alignAllBottom, metrics: nil, views: views)
        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|[roundedView]|", options:.alignAllBottom, metrics: nil, views: views)
        let constraints = horizont + vertical
        NSLayoutConstraint.activate(constraints)
    }
    
    func expandAnimation<T:UIView>(forView: T) where T:AnimatableCircle {
        let options: UIViewAnimationOptions = []
        let initialBounds = forView.bounds
        forView.superview?.layoutIfNeeded()
        let destinationBounds = forView.bounds
        forView.animateFrameAndPathOfImageView(initial: initialBounds, destination: destinationBounds, duration: self.duration, options: options)
    }
    
}
