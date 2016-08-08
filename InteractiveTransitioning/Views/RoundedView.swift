//
//  RoundedView.swift
//  InteractiveTransitioning
//
//  Created by Danis Ziganshin on 24/07/16.
//  Copyright © 2016 Zigdanis. All rights reserved.
//

import UIKit

class RoundedView: UIView {
    var image: UIImage?
    private var imageView: UIImageView
    
    init(_ image: UIImage) {
        self.imageView = UIImageView()
        super.init(frame: CGRect())
        self.image = image
        
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        setupImageView()
        addSubview(imageView)
        setupConstraints()
        addMaskLayer()
    }
    
    func setupImageView() {
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        let views = ["imageView": imageView]
        let horizont = NSLayoutConstraint.constraints(withVisualFormat: "H:|-imageView-|", metrics: nil, views: views)
        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|-imageView-|", metrics: nil, views: views)
        NSLayoutConstraint.activate(horizont + vertical)
    }
    
    func addMaskLayer() {
        let maskLayer = CAShapeLayer()
        maskLayer.fillColor = UIColor.white().cgColor
        maskLayer.lineWidth = 0
        let arcPath = CGPath(ellipseIn: bounds, transform: nil)
        maskLayer.path = arcPath
        layer.mask = maskLayer
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    func moveToPoint(point: CGPoint) {
        
    }
}
