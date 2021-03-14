//
//  APIURL.swift
//  UnsplashUIKit
//
//  Created by Evgeny Novgorodov on 02.01.2021.
//

import Foundation

enum APIURL {
    case randomPhotos(count: Int)
    case searchPhotos(query: String, orderBy: String, count: Int)
    case searchCollections(query: String, orderBy: String, count: Int)
    case listCollections(count: Int)
    case collectionPhotos(id: String, count: Int)
    
    var url: URL? {
        let baseURL = APIConstant.baseURL
        
        switch self {
        case .randomPhotos(let count):
            let stringURL = baseURL + "/photos/random?count=\(count)"
            return URL(string: stringURL)
        case let .searchPhotos(query, orderBy, count):
            let stringURL = baseURL + "/search/photos?query=\(query)&order_by=\(orderBy)&per_page=\(count)"
            return URL(string: stringURL.urlEncoded() ?? "")
        case let .searchCollections(query, orderBy, count):
            let stringURL = baseURL + "/search/collections?query=\(query)&order_by=\(orderBy)&per_page=\(count)"
            return URL(string: stringURL.urlEncoded() ?? "")
        case .listCollections(let count):
            // Тут немного захардкодил просто чтобы разные коллекции отображались
            let randomPage = Int.random(in: 0...100)
            let stringURL = baseURL + "/collections?page=\(randomPage)&per_page=\(count)"
            return URL(string: stringURL)
        case let .collectionPhotos(id, count):
            let stringURL = baseURL + "/collections/\(id)/photos?per_page=\(count)"
            return URL(string: stringURL)
        }
    }
}
