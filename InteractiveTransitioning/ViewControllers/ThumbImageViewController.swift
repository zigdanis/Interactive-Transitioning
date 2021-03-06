//
//  ViewController.swift
//  InteractiveTransitioning
//
//  Created by Danis Ziganshin on 15/07/16.
//  Copyright © 2016 Zigdanis. All rights reserved.
//

import UIKit

class ThumbImageViewController: UIViewController {

    @IBOutlet weak var thumbImageView: RoundedImageView!
    let transitionController = TransitioningDelegate()
    var startPoint: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGestureRecognizers()
        startPoint = thumbImageView.center
        view.backgroundColor = UIColor.groupTableViewBackground
    }
    
    func setupGestureRecognizers() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        thumbImageView.addGestureRecognizer(panGesture)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        thumbImageView.addGestureRecognizer(tapGesture)
    }
    
    func handlePanGesture(gesture: UIGestureRecognizer) {
        let location = gesture.location(in: view)
        let xDist = location.x - startPoint.x
        let yDist = location.y - startPoint.y
        let distance = sqrt(xDist * xDist + yDist * yDist)
        let newFrame = CGRect(x:0,y:0,width:150 + distance,height: 150 + distance)
        thumbImageView.frame = newFrame
        thumbImageView.center = startPoint
    }
    
    func handleTapGesture(gesture: UIGestureRecognizer) {
        guard let secondVC = storyboard?.instantiateViewController(withIdentifier: "FullImageViewController") else {
            return
        }
        let navController = UINavigationController(rootViewController: secondVC)
        navController.modalPresentationStyle = .custom
        navController.transitioningDelegate = transitionController
        present(navController, animated: true)
    }
}

