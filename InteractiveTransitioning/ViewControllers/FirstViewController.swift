//
//  ViewController.swift
//  InteractiveTransitioning
//
//  Created by Danis Ziganshin on 15/07/16.
//  Copyright © 2016 Zigdanis. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGestureRecognizers()
    }
    
    func setupGestureRecognizers() {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture))
        avatarImageView.addGestureRecognizer(gesture)
    }
    
    func handleGesture(gesture: UIGestureRecognizer) {
        avatarImageView.center = gesture.location(in: view)
    }
}

