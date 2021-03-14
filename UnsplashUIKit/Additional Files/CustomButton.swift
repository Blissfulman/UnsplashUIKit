//
//  MainViewButton.swift
//  UnsplashUIKit
//
//  Created by Evgeny Novgorodov on 04.01.2021.
//

import UIKit

final class CustomButton: UIButton {

    override func draw(_ rect: CGRect) {        
        layer.backgroundColor = isEnabled
            ? UIColor(named: "CustomVioletColor")?.cgColor
            : UIColor(named: "CustomVioletColor")?.withAlphaComponent(0.5).cgColor
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .boldSystemFont(ofSize: 18)
        layer.cornerRadius = bounds.height / 2
        contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }
}
