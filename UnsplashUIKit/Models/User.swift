//
//  User.swift
//  UnsplashUIKit
//
//  Created by User on 04.01.2021.
//

import Foundation

// MARK: - User
struct User: Decodable {
    let id: String?
    let username: String?
    let name: String?
    let firstName: String?
    let lastName: String?
    let links: UserLinks?
    let profileImage: ProfileImage?
    let totalCollections, totalLikes, totalPhotos: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case username, name
        case firstName = "first_name"
        case lastName = "last_name"
        case links
        case profileImage = "profile_image"
        case totalCollections = "total_collections"
        case totalLikes = "total_likes"
        case totalPhotos = "total_photos"
    }
}

// MARK: - UserLinks
struct UserLinks: Decodable {
    let html: String?
    let photos: String?
    let likes: String?
}

// MARK: - ProfileImage
struct ProfileImage: Decodable {
    let small: String?
    let medium: String?
    let large: String?
}
