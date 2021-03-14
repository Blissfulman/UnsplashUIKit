//
//  BlockingView.swift
//  UnsplashUIKit
//
//  Created by Evgeny Novgorodov on 09.01.2021.
//

import UIKit

/// Блокирующее вью с индикатором активности, отображаемое во время загрузки данных.
final class BlockingView {
    
    static var activityIndicator = UIActivityIndicatorView()
    
    static func show(parentView: UIView) {
        DispatchQueue.main.async {
            setup(parentView: parentView)
            activityIndicator.startAnimating()
            activityIndicator.isHidden = false
        }
    }
    
    static func hide() {
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
    
    private static func setup(parentView: UIView) {
        activityIndicator.frame = parentView.frame
        activityIndicator.backgroundColor = UIColor(white: 0, alpha: 0.4)
        activityIndicator.color = .white
        activityIndicator.style = .medium
        activityIndicator.hidesWhenStopped = true
        
        parentView.addSubview(activityIndicator)
    }
}
