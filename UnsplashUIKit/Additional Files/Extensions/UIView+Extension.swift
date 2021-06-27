//
//  UIView+Extension.swift
//  UnsplashUIKit
//
//  Created by Evgeny Novgorodov on 27.06.2021.
//

import UIKit

extension UIView {
    
    /// Устанавливает переданный радиус скругления углов.
    /// - Parameter value: Значение радиуса.
    func setCornerRadius(_ value: CGFloat) {
        layer.cornerCurve = .continuous
        layer.cornerRadius = value
        clipsToBounds = true
    }
}
