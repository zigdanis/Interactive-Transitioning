//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
containerView.backgroundColor = UIColor.red
PlaygroundPage.current.liveView = containerView


let duration = 3.0

let roundedView = RoundedCornersView(image: UIImage(named: "close-winter.jpg"))
containerView.addSubview(roundedView)

func setupInitialConstraints() -> [NSLayoutConstraint] {
    let views = ["roundedView": roundedView]
    let horizont = NSLayoutConstraint.constraints(withVisualFormat: "H:[roundedView(100)]-10-|", options:.alignAllBottom, metrics: nil, views: views)
    let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:[roundedView(200)]-10-|", options:.alignAllBottom, metrics: nil, views: views)
    let constraints = horizont + vertical
    NSLayoutConstraint.activate(constraints)
    return constraints
}

func setupAfterAnimationConstraints() -> [NSLayoutConstraint] {
    let views = ["roundedView": roundedView]
    let horizont = NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[roundedView(600)]", options:.alignAllBottom, metrics: nil, views: views)
    let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[roundedView(300)]", options:.alignAllBottom, metrics: nil, views: views)
    let constraints = horizont + vertical
    NSLayoutConstraint.activate(constraints)
    return constraints
}

func animateConstraints() {
    let constraints = setupInitialConstraints()
    containerView.layoutIfNeeded()
    NSLayoutConstraint.deactivate(constraints)
    setupAfterAnimationConstraints()
    shrinkAnimate()
}



func shrinkAnimate() {
    let options: UIViewAnimationOptions = [.autoreverse, .repeat, .curveEaseInOut]
    UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
        let initialBounds = roundedView.bounds
        containerView.layoutIfNeeded()
        let destinationBounds = roundedView.bounds
        roundedView.animateFrameAndPathOfImageView(initial: initialBounds, destination: destinationBounds, duration: duration, options: options)
    })
}


animateConstraints()

