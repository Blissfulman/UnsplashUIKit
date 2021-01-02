//
//  RequestService.swift
//  UnsplashUIKit
//
//  Created by User on 02.01.2021.
//

import Foundation

protocol RequestServiceProtocol {
    var accessKey: String { get }
    func request(url: URL, httpMethod: HTTPMethod) -> URLRequest
}

final class RequestService: RequestServiceProtocol {
        
    var accessKey: String {
        NetworkService.accessKey
    }
        
    func request(url: URL, httpMethod: HTTPMethod) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Client-ID \(accessKey)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}
