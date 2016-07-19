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
    
    let duration:TimeInterval = 2
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let inView = transitionContext.containerView()
        guard let toNavVC = transitionContext.viewController(forKey: UITransitionContextToViewControllerKey) as? UINavigationController else {
            return
        }
        let secondVC = toNavVC.viewControllers.first as! SecondViewController
        let toView = toNavVC.view!
        let imageView = secondVC.fullImageView!
        inView.addSubview(toView)
        imageView.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        imageView.center = toView.center
        toNavVC.navigationBar.alpha = 0
        UIView.animate(withDuration: duration, animations: {
            imageView.frame = toView.frame
            toNavVC.navigationBar.alpha = 1
        }) { (finished) in
            transitionContext.completeTransition(true)
        }
    }
    
}

class InteractionController: NSObject, UIViewControllerInteractiveTransitioning {
    
    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        
    }
}
