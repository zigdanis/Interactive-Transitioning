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

let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
containerView.backgroundColor = UIColor.red()
PlaygroundPage.current.liveView = containerView
let oldSide = 50
let view = UIView(frame: CGRect(x:225,y:225, width: oldSide, height: oldSide))
view.backgroundColor = UIColor.green()
containerView.addSubview(view)


let image = UIImage(named: "close-winter.jpg")
let imageview = UIImageView(image: image)
imageview.contentMode = .scaleAspectFill
imageview.frame = view.bounds
view.clipsToBounds = true
view.addSubview(imageview)

UIView.animate(withDuration: 5, delay: 0, options: .beginFromCurrentState, animations: {
//    imageview.transform = CGAffineTransform(scaleX: 3, y: 3)
    let newSide = 300
    let offset = CGFloat((oldSide - newSide)/2)
    var viewTransform = CGAffineTransform(translationX:offset, y: offset)
    let scaling = CGFloat(newSide/oldSide)
    viewTransform = CGAffineTransform(scaleX:scaling , y: scaling)
//    viewTransform = viewTransform.concat()
    view.transform = viewTransform
}, completion: nil)

//UIView.animate(withDuration: 6) {
//view.bounds = CGRect(x: 250, y: 250, width: 300, height: 300)
//view.center = CGPoint(x: 250, y: 250)
//}




