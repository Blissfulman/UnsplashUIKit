//
//  RequestService.swift
//  UnsplashUIKit
//
//  Created by User on 02.01.2021.
//

import Foundation

protocol RequestServiceProtocol {
    func request(url: URL, httpMethod: HTTPMethod) -> URLRequest
}

final class RequestService: RequestServiceProtocol {
        
    func request(url: URL, httpMethod: HTTPMethod) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.addValue("Client-ID \(NetworkConstants.accessKey)",
                         forHTTPHeaderField: "Authorization")
        
        return request
    }
}
