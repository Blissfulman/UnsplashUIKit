//
//  LoadingView.swift
//  UnsplashUIKit
//
//  Created by User on 09.01.2021.
//

import UIKit

/// Вью с индикатором активности, отображаемое во время загрузки данных.
final class LoadingView {
        
    static var activityIndicator: UIActivityIndicatorView?
    
    static func show(parentView: UIView) {
        DispatchQueue.main.async {
            setup(parentView: parentView)
            activityIndicator?.startAnimating()
            activityIndicator?.isHidden = false
        }
    }
    
    static func hide() {
        DispatchQueue.main.async {
            activityIndicator?.stopAnimating()
            activityIndicator?.removeFromSuperview()
        }
    }
    
    private static func setup(parentView: UIView) {
        activityIndicator = UIActivityIndicatorView(frame: parentView.frame)
        
        activityIndicator?.backgroundColor = UIColor(white: 0, alpha: 0.5)
        activityIndicator?.color = .white
        activityIndicator?.style = .medium
        activityIndicator?.hidesWhenStopped = true
        activityIndicator?.isHidden = true
        
        guard let activityIndicator = activityIndicator else { return }
        
        parentView.addSubview(activityIndicator)
    }
}
