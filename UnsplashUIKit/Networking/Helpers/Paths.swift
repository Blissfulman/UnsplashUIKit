//
//  Paths.swift
//  UnsplashUIKit
//
//  Created by User on 02.01.2021.
//

enum PhotosPath {
    static let getPhoto = "/photos/:id"
    static let getRandomPhoto = "/photos/random"
}

enum SearchPath {
    static let searchPhotos = "/search/photos"
    static let searchCollections = "/search/collections"
}

enum CollectionsPath {
    static let listCollections = "/collections"
    static let getCollection = "/collections/:id"
    static let getCollectionPhotos = "/collections/:id/photos"
}
