//
//  SearchPhotosModel.swift
//  UnsplashUIKit
//
//  Created by User on 05.01.2021.
//

import Foundation

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
