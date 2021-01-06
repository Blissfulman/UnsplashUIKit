//
//  MainViewButton.swift
//  UnsplashUIKit
//
//  Created by User on 04.01.2021.
//

import UIKit

final class MainViewButton: UIButton {

    override func draw(_ rect: CGRect) {
        layer.backgroundColor = CGColor.init(red: 0.3, green: 0, blue: 1, alpha: 0.5)
        tintColor = .white
        titleLabel?.font = .boldSystemFont(ofSize: 18)
        layer.cornerRadius = self.bounds.height / 2
        contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }
}
