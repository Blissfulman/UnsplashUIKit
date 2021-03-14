//
//  SearchPhotosModel.swift
//  UnsplashUIKit
//
//  Created by Evgeny Novgorodov on 05.01.2021.
//

struct SearchPhotosModel: Decodable {
    let total: Int?
    let totalPages: Int?
    let photos: [PhotoModel]?
    
    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case photos = "results"
    }
}
