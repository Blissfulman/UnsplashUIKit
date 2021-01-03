//
//  Collection.swift
//  UnsplashUIKit
//
//  Created by User on 03.01.2021.
//

import Foundation

// MARK: - Collection
struct Collection: Decodable {
    let id, title: String?
    let welcomeDescription: String?
//    let publishedAt, lastCollectedAt, updatedAt: Date?
    let curated, featured: Bool?
    let totalPhotos: Int?
    let welcomePrivate: Bool?
    let shareKey: String?
//    let tags: [Tag]?
//    let links: WelcomeLinks?
//    let user: User?
    let coverPhoto: CoverPhoto?
//    let previewPhotos: [PreviewPhoto]?

    enum CodingKeys: String, CodingKey {
        case id, title
        case welcomeDescription = "description"
//        case publishedAt = "published_at"
//        case lastCollectedAt = "last_collected_at"
//        case updatedAt = "updated_at"
        case curated, featured
        case totalPhotos = "total_photos"
        case welcomePrivate = "private"
        case shareKey = "share_key"
//        case tags, links, user
        case coverPhoto = "cover_photo"
//        case previewPhotos = "preview_photos"
    }
}

// MARK: - CoverPhoto
struct CoverPhoto: Codable {
    let id: String?
//    let createdAt, updatedAt: Date?
//    let promotedAt: Date?
    let width, height: Int?
    let color, blurHash: String?
    let coverPhotoDescription, altDescription: String?
    let urls: Urls?
//    let links: CoverPhotoLinks?
//    let categories: [JSONAny]?
//    let likes: Int?
//    let likedByUser: Bool?
//    let currentUserCollections: [JSONAny]?
//    let sponsorship: JSONNull?
//    let user: User?

    enum CodingKeys: String, CodingKey {
        case id
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//        case promotedAt = "promoted_at"
        case width, height, color
        case blurHash = "blur_hash"
        case coverPhotoDescription = "description"
        case altDescription = "alt_description"
        case urls
//        case links, categories, likes
//        case likedByUser = "liked_by_user"
//        case currentUserCollections = "current_user_collections"
//        case sponsorship, user
    }
}
