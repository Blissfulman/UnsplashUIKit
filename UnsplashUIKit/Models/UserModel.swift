//
//  UserModel.swift
//  UnsplashUIKit
//
//  Created by User on 04.01.2021.
//

// MARK: - UserModel
struct UserModel: Decodable {
    let id: String?
    let username: String?
    let name: String?
    let firstName: String?
    let lastName: String?
    let links: UserLinksModel?
    let profileImage: ProfileImageModel?
    let totalCollections: Int?
    let totalLikes: Int?
    let totalPhotos: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case name
        case firstName = "first_name"
        case lastName = "last_name"
        case links
        case profileImage = "profile_image"
        case totalCollections = "total_collections"
        case totalLikes = "total_likes"
        case totalPhotos = "total_photos"
    }
}

// MARK: - UserLinksModel
struct UserLinksModel: Decodable {
    let html: String?
    let photos: String?
    let likes: String?
}

// MARK: - ProfileImageModel
struct ProfileImageModel: Decodable {
    let small: String?
    let medium: String?
    let large: String?
}
