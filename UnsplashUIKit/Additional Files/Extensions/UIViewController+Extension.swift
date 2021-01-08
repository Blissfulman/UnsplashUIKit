//
//  UIViewController+Extension.swift
//  UnsplashUIKit
//
//  Created by User on 08.01.2021.
//

import UIKit

extension UIViewController {
    
    func showAlert(_ error: Error?) {
        var alertTitle = "Unknown error!"
        var alertMessage = "Please, try again later"
        
        if let error = error as? ServerError {
            alertTitle = error.rawValue
            alertMessage = ""
        }
        
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: alertTitle,
                                          message: alertMessage,
                                          preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(okAction)
            self?.present(alert, animated: true)
        }
    }
    
    func showEmptyResultAlert() {
        let alert = UIAlertController(title: "Search result is empty",
                                      message: "Try entering another search terms",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
