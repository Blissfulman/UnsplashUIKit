//
//  URLService.swift
//  UnsplashUIKit
//
//  Created by User on 02.01.2021.
//

import Foundation

protocol URLServiceProtocol {
    func getURL(forPath path: String) -> URL?
}

final class URLService: URLServiceProtocol {
    
    private let scheme = "https"
    private let host = "api.unsplash.com"
    
    func getURL(forPath path: String) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        
        return urlComponents.url
    }
}
