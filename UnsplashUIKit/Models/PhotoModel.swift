//
//  PhotoModel.swift
//  UnsplashUIKit
//
//  Created by User on 03.01.2021.
//

import Foundation

// MARK: - PhotoModel
struct PhotoModel: Decodable {
    let id: String?
    let createdAt: Date?
    let updatedAt: Date?
    let promotedAt: Date?
    let width: Int?
    let height: Int?
    let color: String?
    let description: String?
    let altDescription: String?
    let urls: PhotoUrlsModel?
    //    let links: PhotoLinks?
    let likes: Int?
    let user: UserModel?
    let location: LocationModel?
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

// MARK: - PhotoUrlsModel
struct PhotoUrlsModel: Decodable {
    let raw: String?
    let full: String?
    let regular: String?
    let small: String?
    let thumb: String?
}

// MARK: - LocationModel
struct LocationModel: Decodable {
    let title: String?
    let name: String?
    let city: String?
    let country: String?
    let position: PositionModel?
}

// MARK: - PositionModel
struct PositionModel: Decodable {
    let latitude: Double?
    let longitude: Double?
}
