//
//  SecondViewController.swift
//  InteractiveTransitioning
//
//  Created by Danis Ziganshin on 18/07/16.
//  Copyright © 2016 Zigdanis. All rights reserved.
//

import UIKit

class FullImageViewController: UIViewController {
    
    @IBOutlet weak var fullImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        view.backgroundColor = UIColor.groupTableViewBackground
    }
    
    func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(closeViewController))
    }
    
    func closeViewController() {
        dismiss(animated: true)
    }
    
}
