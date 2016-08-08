//
//  RoundedView.swift
//  InteractiveTransitioning
//
//  Created by Danis Ziganshin on 24/07/16.
//  Copyright © 2016 Zigdanis. All rights reserved.
//

import UIKit

public class RoundedView: UIView {
    var image: UIImage?
    public var imageView: UIImageView
    public var maskLayer = CAShapeLayer()
    
    public init(_ image: UIImage, frame: CGRect) {
        self.imageView = UIImageView(image: image)
        self.imageView.frame = CGRect(origin: CGPoint(), size: frame.size)
        super.init(frame: frame)
        self.image = image
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        setupImageView()
        addMaskLayer()
    }
    
    func setupImageView() {
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        setupConstraints()
    }
    
    func setupConstraints() {
        let views = ["imageView": imageView]
        let horizont = NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[imageView]-10-|", metrics: nil, views: views)
        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[imageView]-10-|", metrics: nil, views: views)
        NSLayoutConstraint.activate(horizont + vertical)
    }
    
    public func addMaskLayer() {
        maskLayer.fillColor = UIColor.white().cgColor
        maskLayer.lineWidth = 0
        let rect = imageView.bounds
        let arcPath = CGPath(ellipseIn: rect, transform: nil)
        print("rect = \(rect)")
        maskLayer.path = arcPath
        maskLayer.frame = rect
        imageView.layer.mask = maskLayer
    }
        
    required public init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
}
