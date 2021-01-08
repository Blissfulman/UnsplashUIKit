//
//  ErrorManager.swift
//  UnsplashUIKit
//
//  Created by User on 08.01.2021.
//

final class ErrorManager {
    
    static func showErrorDescription(error: Error) {
        if let serverError = error as? ServerError {
            print(serverError.rawValue)
            return
        }
        print(error.localizedDescription)
    }
}
