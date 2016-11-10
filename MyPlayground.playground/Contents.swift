//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

let duration = 3.0

let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: 700))
containerView.backgroundColor = UIColor.red
PlaygroundPage.current.liveView = containerView

let roundedView = RoundedImageView(image: UIImage(named: "close-winter.jpg"))
containerView.addSubview(roundedView)

func FfullConstraints() -> [NSLayoutConstraint] {
    let constraints = [
        roundedView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
        roundedView.topAnchor.constraint(equalTo: containerView.topAnchor),
        roundedView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        roundedView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
    ]
    return constraints
}

func FsmallConstraintsF() -> [NSLayoutConstraint] {
    let constraints = [
        roundedView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant:-20),
        roundedView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant:-20),
        roundedView.widthAnchor.constraint(equalToConstant: 230),
        roundedView.heightAnchor.constraint(equalToConstant: 130)
    ]
    return constraints
}

var fullConstraints = FfullConstraints()
var smallConstraints = FsmallConstraintsF()

func keyFrameAnimation() {
    NSLayoutConstraint.activate(fullConstraints)
    containerView.layoutIfNeeded()
    let destinationRect = roundedView.bounds
    NSLayoutConstraint.deactivate(fullConstraints)
    NSLayoutConstraint.activate(smallConstraints)
    containerView.layoutIfNeeded()
    let initialRect = roundedView.bounds
    
    let options: UIViewAnimationOptions = [.curveEaseInOut]
    UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
        NSLayoutConstraint.deactivate(smallConstraints)
        NSLayoutConstraint.activate(fullConstraints)
        containerView.layoutIfNeeded()
    }, completion: { state in
        print("UIView animation completed")
    })
    
    roundedView.animateImageViewWithExpand(initial: initialRect, destination: destinationRect, duration: duration, options: options)
    roundedView.animationCompletion = {
        print("CAAnimation did completed")
    }
}

keyFrameAnimation()
