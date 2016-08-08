//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
containerView.backgroundColor = UIColor.red()
PlaygroundPage.current.liveView = containerView


let oldSide = 100
let newSide = 300
let duration = 1.0
let from = CGRect(x: 490 - oldSide, y: 490-oldSide, width: oldSide, height: oldSide)
let to = CGRect(x: 10, y: 10, width: newSide, height: newSide)
let fromCenter = CGPoint(x: from.midX, y:from.midY)
let toCenter = CGPoint(x: to.midX, y: to.midY)

let roundedView = RoundedView(UIImage(named: "close-winter.jpg")!, frame:CGRect(x: 200, y: 200, width:oldSide, height: oldSide))
roundedView.translatesAutoresizingMaskIntoConstraints = false
roundedView.backgroundColor = UIColor.yellow()
containerView.addSubview(roundedView)

func setupInitialConstraints() -> [NSLayoutConstraint] {
    let views = ["roundedView": roundedView]
    let horizont = NSLayoutConstraint.constraints(withVisualFormat: "H:[roundedView(100)]-10-|", options:.alignAllBottom, metrics: nil, views: views)
    let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:[roundedView(100)]-10-|", options:.alignAllBottom, metrics: nil, views: views)
    let constraints = horizont + vertical
    NSLayoutConstraint.activate(constraints)
    return constraints
}

func setupAfterAnimationConstraints() {
    let views = ["roundedView": roundedView]
    let horizont = NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[roundedView(300)]", options:.alignAllBottom, metrics: nil, views: views)
    let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[roundedView(300)]", options:.alignAllBottom, metrics: nil, views: views)
    NSLayoutConstraint.activate(horizont + vertical)
}

func animateLayer() {
    let position = CABasicAnimation(keyPath: "position")
    position.fromValue = NSValue(cgPoint: fromCenter)
    position.toValue = NSValue(cgPoint: toCenter)
    
    let bounds = CABasicAnimation(keyPath: "bounds")
    bounds.fromValue = NSValue(cgRect: from)
    bounds.toValue = NSValue(cgRect: to)
    
    let group = CAAnimationGroup()
    group.duration = duration
    group.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    group.animations = [position, bounds]
    group.isRemovedOnCompletion = false
    group.fillMode = kCAFillModeForwards
    roundedView.layer.add(group, forKey: "allAnimations")
}

func animateConstraints() {
    let constraints = setupInitialConstraints()
    containerView.layoutIfNeeded()
    NSLayoutConstraint.deactivate(constraints)
    setupAfterAnimationConstraints()
    UIView.animate(withDuration: duration) {
        containerView.layoutIfNeeded()
    }
}

func animateImageView() {
    let position = CABasicAnimation(keyPath: "position")
    position.fromValue = NSValue(cgPoint: CGPoint(x: 50, y:50))
    position.toValue = NSValue(cgPoint: CGPoint(x: 160, y: 160))
    
    let bounds = CABasicAnimation(keyPath: "bounds")
    bounds.fromValue = NSValue(cgRect: from)
    bounds.toValue = NSValue(cgRect: to)
    
    let group = CAAnimationGroup()
    group.duration = duration
    group.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    group.animations = [position, bounds]
    group.isRemovedOnCompletion = false
    group.fillMode = kCAFillModeForwards
    roundedView.imageView.layer.add(group, forKey: "allAnimations2")
    roundedView.layer.presentation()
}

func animateTransaction() {
    CATransaction.begin()
    animateLayer()
    animateImageView()
    CATransaction.commit()
}

func animateImplicit() {
    CATransaction.begin()
    roundedView.layer.position = CGPoint(x:200,y:200)
    roundedView.layer.bounds = to
    CATransaction.commit()
}

func animateFrameAndPathOfImageView(initial: CGRect, destination: CGRect, duration: TimeInterval) {
    let boundsAnimation = CABasicAnimation(keyPath: "bounds")
    boundsAnimation.fromValue = NSValue(cgRect: initial)
    boundsAnimation.toValue = NSValue(cgRect: destination)
    
    let pathAnimation = CABasicAnimation(keyPath: "path")
    pathAnimation.fromValue = CGPath(ellipseIn: initial, transform: nil)
    let toPath = CGPath(ellipseIn: destination, transform: nil)
    pathAnimation.toValue = toPath
    
    let positionAnimation = CABasicAnimation(keyPath: "position")
    positionAnimation.fromValue = NSValue(cgPoint: CGPoint(x: 40, y: 40))
    positionAnimation.toValue = NSValue(cgPoint: CGPoint(x: 230, y: 230))

    let group = CAAnimationGroup()
    group.duration = duration
    group.animations = [boundsAnimation, pathAnimation, positionAnimation]
    group.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    group.autoreverses = true
    group.repeatCount = 1000

    
    roundedView.maskLayer.path = toPath
    roundedView.maskLayer.bounds = destination
    roundedView.maskLayer.position = CGPoint(x: 230, y: 230)
    roundedView.maskLayer.add(group, forKey: "path")
}



setupInitialConstraints()
containerView.layoutIfNeeded()

roundedView.addMaskLayer()
setupAfterAnimationConstraints()

UIView.animate(withDuration: 6, delay: 0, options: [.autoreverse, .repeat], animations: {
    let initialBounds = roundedView.imageView.bounds
    containerView.layoutIfNeeded()
    let destinationBounds = roundedView.imageView.bounds
    animateFrameAndPathOfImageView(initial: initialBounds, destination: destinationBounds, duration: 6)
})




