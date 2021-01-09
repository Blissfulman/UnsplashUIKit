//
//  SearchCollectionsModel.swift
//  UnsplashUIKit
//
//  Created by User on 07.01.2021.
//

struct SearchCollectionsModel: Decodable {
    let total: Int?
    let totalPages: Int?
    let collections: [CollectionModel]?
    
    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case collections = "results"
    }
}
