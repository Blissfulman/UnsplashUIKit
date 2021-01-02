//
//  UIView+Extension.swift
//  UnsplashUIKit
//
//  Created by User on 03.01.2021.
//

import UIKit

extension UIView {
    func appearAnimation(fromValue: Float = 0, toValue: Float = 1, duration: Double = 1) {
        let animation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.duration = duration
        self.layer.add(animation, forKey: "opacity")
        self.layer.opacity = toValue
    }
}
