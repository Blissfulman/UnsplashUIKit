//
//  RequestService.swift
//  UnsplashUIKit
//
//  Created by Evgeny Novgorodov on 02.01.2021.
//

import Foundation

// MARK: - Protocols

protocol RequestServiceProtocol {
    
    /// Получение URLRequest с переданными параметрами и данными для авторизации.
    /// - Parameters:
    ///   - url: URL запроса.
    ///   - httpMethod: HTTP метод запроса.
    func getRequest(url: URL, httpMethod: HTTPMethod) -> URLRequest
}

final class RequestService: RequestServiceProtocol {
        
    func getRequest(url: URL, httpMethod: HTTPMethod) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.addValue("Client-ID \(APIConstant.accessKey)", forHTTPHeaderField: "Authorization")
        return request
    }
}
