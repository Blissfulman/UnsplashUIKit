//
//  MainViewButton.swift
//  UnsplashUIKit
//
//  Created by User on 04.01.2021.
//

import UIKit

final class CustomButton: UIButton {

    override func draw(_ rect: CGRect) {
        layer.backgroundColor = UIColor(named: "CustomVioletColor")?.cgColor
        tintColor = .white
        titleLabel?.font = .boldSystemFont(ofSize: 18)
        layer.cornerRadius = bounds.height / 2
        contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }
}
