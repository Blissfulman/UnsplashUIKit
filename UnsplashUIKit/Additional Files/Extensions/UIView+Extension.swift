//
//  UIView+Extension.swift
//  UnsplashUIKit
//
//  Created by User on 03.01.2021.
//

import UIKit

extension UIView {
    func appearAnimation(fromValue: Float = 0, toValue: Float = 1, duration: Double = 1) {
        isHidden = false
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.duration = duration
        self.layer.add(animation, forKey: nil)
        self.layer.opacity = toValue
    }
    
//    func resizeAnimation(toSize: CGPoint, duration: Double = 1) {
//        let animation = CABasicAnimation(keyPath: "position")
//        animation.fromValue = CGPoint(x: self.frame.minX, y: self.frame.minY)
//        animation.toValue = toSize
//        animation.duration = duration
//        self.layer.add(animation, forKey: nil)
//        self.layer.position = toSize
//    }
}
