//
//  Collection.swift
//  UnsplashUIKit
//
//  Created by User on 03.01.2021.
//

import Foundation

// MARK: - Collection
struct Collection: Decodable {
    let id: String?
    let title: String?
    let description: String?
    let publishedAt: Date?
    let lastCollectedAt: Date?
    let updatedAt: Date?
    let totalPhotos: Int?
    let links: CollectionLinks?
    let user: User?
    let coverPhoto: Photo?
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

// MARK: - CollectionLinks
struct CollectionLinks: Decodable {
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
