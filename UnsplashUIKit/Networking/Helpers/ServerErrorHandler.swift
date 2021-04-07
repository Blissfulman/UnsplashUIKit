//
//  ServerErrorHandler.swift
//  UnsplashUIKit
//
//  Created by Evgeny Novgorodov on 07.04.2021.
//

import Foundation

final class ServerErrorHandler {
    
    /// Обработка ошибок сервера, по статус-коду в response.
    /// - Parameters:
    ///   - response: Ответ от сервера.
    ///   - completion: Замыкание, в которое возвращается ошибка от сервера. Вызывается, если в ответе от сервера статус-код не равен 200.
    /// - Returns: Возвращает true если в ответ от сервера пришёл статус-код 200, в иных случаях возвращает false.
    static func handle<T>(_ response: HTTPURLResponse, completion: ResultBlock<T>) -> Bool {
        if response.statusCode == 200 {
            return true
        } else {
            guard let serverError = ServerError(rawValue: response.statusCode) else {
                completion(.failure(ServerError.unknownError), nil)
                return false
            }
            completion(.failure(serverError), nil)
            return false
        }
    }
}
