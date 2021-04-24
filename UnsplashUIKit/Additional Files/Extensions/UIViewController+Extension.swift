//
//  UIViewController+Extension.swift
//  UnsplashUIKit
//
//  Created by Evgeny Novgorodov on 08.01.2021.
//

import UIKit

extension UIViewController {
    
    /// Alert, оповещающий об ошибке.
    func showErrorAlert(_ error: Error?) {
        let isServerError = error is ServerError
        let alertTitle = isServerError ? error?.localizedDescription : "Unknown error!"
        let alertMessage = isServerError ? "" : "Please, try again later"
        
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: alertTitle,
                                          message: alertMessage,
                                          preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(okAction)
            self?.present(alert, animated: true)
        }
    }
    
    /// Alert, оповещающий о пустом результате поиска.
    func showEmptyResultAlert() {
        let alert = UIAlertController(title: "Search result is empty",
                                      message: "Try entering another search terms",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    /// Получение массива IndexPath, соответствующих элементам следующей загруженной странице при пагинации.
    func getNextPageIndexPaths(loadedItems: Int, newItemsCount: Int, section: Int = 0) -> [IndexPath] {
        let indexPaths = (loadedItems..<(loadedItems + newItemsCount)).map {
            IndexPath(item: $0, section: section)
        }
        return indexPaths
    }
}
