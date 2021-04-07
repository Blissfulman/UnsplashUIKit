//
//  CollectionModel.swift
//  UnsplashUIKit
//
//  Created by Evgeny Novgorodov on 03.01.2021.
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
    let user: UserModel?
    let coverPhoto: PhotoModel?
    let previewPhotos: [PreviewPhotoModel]?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case publishedAt = "published_at"
        case lastCollectedAt = "last_collected_at"
        case updatedAt = "updated_at"
        case totalPhotos = "total_photos"
        case user
        case coverPhoto = "cover_photo"
        case previewPhotos = "preview_photos"
    }
}

// MARK: - PreviewPhotoModel

struct PreviewPhotoModel: Decodable {
    let id: String?
    let urls: PhotoUrlsModel?
}
