//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
containerView.backgroundColor = UIColor.red()
PlaygroundPage.current.liveView = containerView

let oldSide = 50
let newSide = 300

let view = UIView(frame: CGRect(x:225,y:225, width: oldSide, height: oldSide))
view.backgroundColor = UIColor.green()
containerView.addSubview(view)


let image = UIImage(named: "close-winter.jpg")
let imageview = UIImageView(image: image)
imageview.contentMode = .scaleAspectFill
imageview.frame = view.bounds
view.clipsToBounds = true
view.addSubview(imageview)

let maskLayer = CAShapeLayer()
maskLayer.fillColor = UIColor.white().cgColor
maskLayer.lineWidth = 0
let arcPath = CGPath(ellipseIn: view.bounds, transform: nil)
maskLayer.path = arcPath
view.layer.mask = maskLayer


UIView.animate(withDuration: 5, delay: 0, options: .beginFromCurrentState, animations: {
    let scaling = CGFloat(newSide/oldSide)
    let viewTransform = CGAffineTransform(scaleX:scaling , y: scaling)
    view.transform = viewTransform
}, completion: nil)





