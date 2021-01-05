//
//  CollectionModel.swift
//  UnsplashUIKit
//
//  Created by User on 03.01.2021.
//

import Foundation

// MARK: - CollectionModel
struct CollectionModel: Decodable {
    let id: String?
    let title: String?
    let description: String?
    let publishedAt: Date?
    let lastCollectedAt: Date?
    let updatedAt: Date?
    let totalPhotos: Int?
    let links: CollectionLinksModel?
    let user: UserModel?
    let coverPhoto: PhotoModel?
//    let previewPhotos: [PreviewPhoto]?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case publishedAt = "published_at"
        case lastCollectedAt = "last_collected_at"
        case updatedAt = "updated_at"
        case totalPhotos = "total_photos"
        case links
        case user
        case coverPhoto = "cover_photo"
//        case previewPhotos = "preview_photos"
    }
}

// MARK: - CollectionLinksModel
struct CollectionLinksModel: Decodable {
    let linksSelf: URL?
    let html: URL?
    let photos: URL?
    let related: URL?

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html
        case photos
        case related
    }
}
