//
//  ViewController.swift
//  InteractiveTransitioning
//
//  Created by Danis Ziganshin on 15/07/16.
//  Copyright © 2016 Zigdanis. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var thumbImageView: RoundedImageView!
    let transitionController = TransitioningDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGestureRecognizers()
    }
    
    func setupGestureRecognizers() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        thumbImageView.addGestureRecognizer(panGesture)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        thumbImageView.addGestureRecognizer(tapGesture)
    }
    
    func handlePanGesture(gesture: UIGestureRecognizer) {
        thumbImageView.center = gesture.location(in: view)
    }
    
    func handleTapGesture(gesture: UIGestureRecognizer) {
        guard let secondVC = storyboard?.instantiateViewController(withIdentifier: "SecondViewController") else {
            return
        }
        let navController = UINavigationController(rootViewController: secondVC)
        navController.modalPresentationStyle = .custom
        navController.transitioningDelegate = transitionController
        present(navController, animated: true)
    }
}

