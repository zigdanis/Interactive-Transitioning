//
//  TransitioningDelegate.swift
//  InteractiveTransitioning
//
//  Created by Danis Ziganshin on 18/07/16.
//  Copyright © 2016 Zigdanis. All rights reserved.
//

import UIKit

class TransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    let animationController = AnimationController()
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animationController
    }
}

class AnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration:TimeInterval = 10
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let inView = transitionContext.containerView()
        guard let toNavVC = transitionContext.viewController(forKey: UITransitionContextToViewControllerKey) as? UINavigationController else {
            return
        }
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextFromViewControllerKey) as? FirstViewController else {
            return
        }
        guard let secondVC = toNavVC.viewControllers.first as? SecondViewController else {
            return
        }
        let fromIV = fromVC.thumbImageView!
        let animatableIV = RoundedImageView()
        animatableIV.clipsToBounds = true
        animatableIV.image = fromIV.image
        animatableIV.contentMode = .scaleAspectFill
        let toView = toNavVC.view!
        
        //Setup
        inView.addSubview(toView)
        animatableIV.frame = fromIV.frame
        toNavVC.navigationBar.alpha = 0
        secondVC.view.alpha = 0
        inView.addSubview(animatableIV)
        
        UIView.animate(withDuration: duration, animations: {
            toNavVC.navigationBar.alpha = 1
            animatableIV.center = secondVC.view.center
            animatableIV.bounds = CGRect(x: 0, y: 0, width: secondVC.view.frame.height, height: secondVC.view.frame.height)
        }) { (finished) in
            animatableIV.removeFromSuperview()
            secondVC.view.alpha = 1
            transitionContext.completeTransition(true)
        }
    }
}

class InteractionController: NSObject, UIViewControllerInteractiveTransitioning {
    
    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        
    }
}
