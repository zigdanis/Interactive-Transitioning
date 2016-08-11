//
//  AnimatableCircle.swift
//  InteractiveTransitioning
//
//  Created by Danis Ziganshin on 11/08/16.
//  Copyright © 2016 Zigdanis. All rights reserved.
//

import Foundation
import UIKit

protocol AnimatableCircle {
    func animateFrameAndPathOfImageView(initial: CGRect, destination: CGRect, duration: TimeInterval, options: UIViewAnimationOptions)
}
