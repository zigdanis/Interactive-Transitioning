//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

var str = "Hello, playground"


let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
containerView.backgroundColor = UIColor.red
PlaygroundPage.current.liveView = containerView

let duration = 3.0

let roundedView = RoundedImageView(image: UIImage(named: "close-winter.jpg"))
containerView.addSubview(roundedView)

func containingCircleRect(for rect: CGRect) -> CGRect {
    let height = rect.height
    let width = rect.width
    let diameter = sqrt((height * height) + (width * width))
    let newX = rect.origin.x - (diameter - width) / 2
    let newY = rect.origin.y - (diameter - height) / 2
    let containerRect = CGRect(x: newX, y: newY, width: diameter, height: diameter)
    return containerRect
}

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
        roundedView.widthAnchor.constraint(equalToConstant: 130),
        roundedView.heightAnchor.constraint(equalToConstant: 130)
    ]
    return constraints
}

var fullConstraints = FfullConstraints()
var smallConstraints = FsmallConstraintsF()

func animate() {
//    let consts = setupSmallConstraints()
    containerView.layoutIfNeeded()
    let initialRect = roundedView.bounds
//    NSLayoutConstraint.deactivate(consts)
//    setupFullConstraints()
    
    let options: UIViewAnimationOptions = []
    UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
        containerView.layoutIfNeeded()
        let destinationRect = roundedView.bounds
        let containerRect = containingCircleRect(for: destinationRect)
        print("initial = \(initialRect)")
        print("destination = \(destinationRect)")
        print("container = \(containerRect)")
        roundedView.animateFrameAndPathOfImageView(initial: initialRect, destination: containerRect, duration: duration, options: options)
    })
}

func keyFrameAnimation() {
    NSLayoutConstraint.activate(smallConstraints)
    containerView.layoutIfNeeded()
    let initialRect = roundedView.bounds
    NSLayoutConstraint.deactivate(smallConstraints)
    NSLayoutConstraint.activate(fullConstraints)
    containerView.layoutIfNeeded()
    let destinationRect = roundedView.bounds
    NSLayoutConstraint.deactivate(fullConstraints)
    NSLayoutConstraint.activate(smallConstraints)
    containerView.layoutIfNeeded()
    
    UIView.animateKeyframes(withDuration: duration, delay: 0, options: [.calculationModeLinear], animations: {
        UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
            containerView.backgroundColor = UIColor.yellow
            NSLayoutConstraint.deactivate(smallConstraints)
            NSLayoutConstraint.activate(fullConstraints)
            containerView.layoutIfNeeded()
        })
        UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
            containerView.backgroundColor = UIColor.blue
            NSLayoutConstraint.deactivate(fullConstraints)
            NSLayoutConstraint.activate(smallConstraints)
            containerView.layoutIfNeeded()
        })
    })
    print("initial 2 = \(initialRect)")
    print("destination 2 = \(destinationRect)")
    roundedView.animateFrameAndPathOfImageViewBackAndForth(initial: initialRect, destination: destinationRect, duration: duration, options: [])
}



keyFrameAnimation()

//animate()

