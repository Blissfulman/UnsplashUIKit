//
//  MainViewButton.swift
//  UnsplashUIKit
//
//  Created by User on 04.01.2021.
//

import UIKit

class MainViewButton: UIButton {

    override func draw(_ rect: CGRect) {
        layer.backgroundColor = CGColor.init(gray: 0, alpha: 0.7)
        tintColor = .white
        titleLabel?.font = .boldSystemFont(ofSize: 24)
        clipsToBounds = true
        layer.cornerRadius = 15
        titleEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        widthAnchor.constraint(equalToConstant: 250).isActive = true
    }
}
