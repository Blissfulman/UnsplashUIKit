//
//  CustomView.swift
//  UnsplashUIKit
//
//  Created by User on 06.01.2021.
//

import UIKit

final class CustomView: UIView {
    
    override func draw(_ rect: CGRect) {        
        clipsToBounds = true
        layer.cornerRadius = bounds.height / 2
    }
}
