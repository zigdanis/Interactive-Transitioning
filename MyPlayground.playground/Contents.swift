//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport
/*
var str = "Hello, playground"
let view = UIView(frame: CGRect(x:0,y:0,width: 100, height: 100))
PlaygroundPage.current.liveView = view
view.backgroundColor = UIColor.red()
let maskLayer = CAShapeLayer()
maskLayer.fillColor = UIColor.white().cgColor
maskLayer.lineWidth = 0
let arcPath = CGPath(ellipseIn: view.bounds, transform: nil)
maskLayer.path = arcPath
view.layer.mask = maskLayer
UIView.animate(withDuration: 3) {
    view.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
    view.layer.mask?.frame = view.frame
}
*/

// fill with yellow
let rectShape = CAShapeLayer()
let view = UIView(frame: CGRect(x:0,y:0,width: 50, height: 50))
view.backgroundColor = UIColor.green()
PlaygroundPage.current.liveView = view
rectShape.fillColor = UIColor.yellow().cgColor

let transaction = CATransaction()
let bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
let startShape = UIBezierPath(roundedRect: bounds, cornerRadius: 50).cgPath
let afterBounds = CGRect(x: 0, y: 0, width: 1000, height: 1000)
let endShape = UIBezierPath(roundedRect:afterBounds , cornerRadius: 500).cgPath

// set initial shape
rectShape.path = startShape
view.layer.addSublayer(rectShape)
// 2
//// animate the `path`
//let animation = CABasicAnimation(keyPath: "path")
//animation.toValue = endShape
//animation.duration = 6
//// 3
//animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut) // animation curve is Ease Out
//animation.fillMode = kCAFillModeBoth // keep to value after finishing
//animation.isRemovedOnCompletion = false // don't remove after finishing
//// 4
//rectShape.add(animation, forKey: animation.keyPath)


CATransaction.begin()
CATransaction.setAnimationDuration(6)
CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
rectShape.path = endShape
CATransaction.commit()


UIView.animate(withDuration: 6) { 
    view.frame = CGRect(x: 0, y: 0, width: 1000, height: 1000)
}





