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
    
    let duration:TimeInterval = 5
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let inView = transitionContext.containerView
        guard let toNavVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? UINavigationController else {
            return
        }
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? FirstViewController else {
            return
        }
        guard let secondVC = toNavVC.viewControllers.first as? SecondViewController else {
            return
        }
        let fromIV = fromVC.thumbImageView!
        let toView = toNavVC.view!
        
        //Setup
        inView.addSubview(toView)
        toNavVC.navigationBar.alpha = 0
        secondVC.view.alpha = 0
        
        let animatableIV = RoundedCornersView(image: fromIV.image)
        inView.addSubview(animatableIV)
        animateConstraints(forView: animatableIV) { completed in
            animatableIV.removeFromSuperview()
            secondVC.view.alpha = 1
            transitionContext.completeTransition(true)
        }
    }
    
    func setupInitialConstraints(forView: UIView) -> [NSLayoutConstraint] {
        let views = ["roundedView": forView]
        let horizont = NSLayoutConstraint.constraints(withVisualFormat: "H:[roundedView(100)]-10-|", options:.alignAllBottom, metrics: nil, views: views)
        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:[roundedView(100)]-10-|", options:.alignAllBottom, metrics: nil, views: views)
        let constraints = horizont + vertical
        NSLayoutConstraint.activate(constraints)
        return constraints
    }
    
    func setupAfterAnimationConstraints(forView: UIView) -> [NSLayoutConstraint] {
        let views = ["roundedView": forView]
        let horizont = NSLayoutConstraint.constraints(withVisualFormat: "H:|[roundedView]|", options:.alignAllBottom, metrics: nil, views: views)
        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|[roundedView]|", options:.alignAllBottom, metrics: nil, views: views)
        let constraints = horizont + vertical
        NSLayoutConstraint.activate(constraints)
        return constraints
    }
    
    func animateConstraints<T:UIView>(forView: T, completion: ((Bool) -> ())?) where T:AnimatableCircle {
        let constraints = setupInitialConstraints(forView: forView)
        forView.superview!.layoutIfNeeded()
        NSLayoutConstraint.deactivate(constraints)
        _ = setupAfterAnimationConstraints(forView: forView)
        shrinkAnimate(forView: forView, completion: completion)
    }
    
    
    func shrinkAnimate<T:UIView>(forView: T, completion: ((Bool) -> ())?) where T:AnimatableCircle {
        let options: UIViewAnimationOptions = [.autoreverse, .repeat, .curveEaseInOut]
//        let options: UIViewAnimationOptions = []
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            let initialBounds = forView.bounds
            forView.superview!.layoutIfNeeded()
            let destinationBounds = forView.bounds
            forView.animateFrameAndPathOfImageView(initial: initialBounds, destination: destinationBounds, duration: self.duration, options: options)
        }, completion: completion)
    }
}

class InteractionController: NSObject, UIViewControllerInteractiveTransitioning {
    
    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        
    }
}
