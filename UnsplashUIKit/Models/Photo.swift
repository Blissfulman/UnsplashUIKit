//
//  Photo.swift
//  UnsplashUIKit
//
//  Created by User on 03.01.2021.
//

import Foundation

// MARK: - Photo
struct Photo: Codable {
    let id: String?
//    let createdAt, updatedAt, promotedAt: Date?
    let width, height: Int?
    let color, blurHash: String?
//    let welcomeDescription: JSONNull?
//    let altDescription: String?
    let urls: Urls?
//    let links: WelcomeLinks?
//    let categories: [JSONAny]?
//    let likes: Int?
//    let likedByUser: Bool?
//    let currentUserCollections: [JSONAny]?
//    let sponsorship: JSONNull?
//    let user: User?
//    let exif: Exif?
//    let location: Location?
//    let views, downloads: Int?

    enum CodingKeys: String, CodingKey {
        case id
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//        case promotedAt = "promoted_at"
        case width, height, color
        case blurHash = "blur_hash"
//        case welcomeDescription = "description"
//        case altDescription = "alt_description"
        case urls
//        case links, categories, likes
//        case likedByUser = "liked_by_user"
//        case currentUserCollections = "current_user_collections"
//        case sponsorship, user, exif, location, views, downloads
    }
}

// MARK: - Urls
struct Urls: Codable {
    let raw, full, regular, small: String?
    let thumb: String?
}
