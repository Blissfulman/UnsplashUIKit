//
//  Photo.swift
//  UnsplashUIKit
//
//  Created by User on 03.01.2021.
//

import Foundation

// MARK: - Photo
struct Photo: Decodable {
    let id: String?
    let createdAt: Date?
    let updatedAt: Date?
    let promotedAt: Date?
    let width: Int?
    let height: Int?
    let color: String?
    let description: String?
    let altDescription: String?
    let urls: PhotoUrls?
    //    let links: PhotoLinks?
    let likes: Int?
    let user: User?
    let location: Location?
    let views: Int?
    let downloads: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case promotedAt = "promoted_at"
        case width
        case height
        case color
        case description
        case altDescription = "alt_description"
        case urls
        //        case links
        case likes
        case user
        case location
        case views
        case downloads
    }
}

// MARK: - PhotoUrls
struct PhotoUrls: Decodable {
    let raw: String?
    let full: String?
    let regular: String?
    let small: String?
    let thumb: String?
}

// MARK: - Location
struct Location: Decodable {
    let title: String?
    let name: String?
    let city: String?
    let country: String?
    let position: Position?
}

// MARK: - Position
struct Position: Decodable {
    let latitude: Double?
    let longitude: Double?
}
