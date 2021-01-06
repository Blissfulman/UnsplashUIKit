//
//  URLService.swift
//  UnsplashUIKit
//
//  Created by User on 02.01.2021.
//

import Foundation

protocol URLServiceProtocol {
    func getURL(forURL url: URL, count: Int?) -> URL?
    func getURL(forPath path: String, count: Int?) -> URL?
    func getURL(forPath path: String, query: String, orderBy: String, count: Int?) -> URL?
}

final class URLService: URLServiceProtocol {
    
    private let scheme = "https"
    private let host = "api.unsplash.com"
    
    func getURL(forURL url: URL, count: Int?) -> URL? {
        
        var stringURL = url.absoluteString
        
        if let count = count {
            stringURL += "?per_page=\(count)"
        }
        
        guard let url = URL(string: stringURL) else { return nil }
        return url
    }
    
    func getURL(forPath path: String, count: Int?) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        
        if let count = count {
            urlComponents.queryItems = [URLQueryItem(name: "count", value: "\(count)")]
        }
        
        return urlComponents.url
    }
    
    func getURL(forPath path: String, query: String, orderBy: String, count: Int?) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        
        if let count = count {
            urlComponents.queryItems = [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "order_by", value: orderBy),
                URLQueryItem(name: "per_page", value: "\(count)")
            ]
        }
        
        return urlComponents.url
    }
}
