//
//  ErrorManager.swift
//  UnsplashUIKit
//
//  Created by Evgeny Novgorodov on 08.01.2021.
//

final class ErrorManager {
    
    // Вывод в консоль описания ошибок
    static func showErrorDescription(error: Error) {
        if let serverError = error as? ServerError {
            print(serverError.localizedDescription)
            return
        }
        print(error.localizedDescription)
    }
}
