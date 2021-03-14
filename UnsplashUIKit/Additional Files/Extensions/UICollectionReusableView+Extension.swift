//
//  UICollectionReusableView+Extension.swift
//  UnsplashUIKit
//
//  Created by Evgeny Novgorodov on 14.03.2021.
//

import UIKit

protocol NibCollectionReusableView {
    static var identifier: String { get }
}

extension UICollectionReusableView: NibCollectionReusableView {
    
    static var identifier: String {
        String(describing: Self.self)
    }
        
    static func nib() -> UINib {
        UINib(nibName: identifier, bundle: nil)
    }
}
