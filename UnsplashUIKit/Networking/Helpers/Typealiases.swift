//
//  Typealiases.swift
//  UnsplashUIKit
//
//  Created by Evgeny Novgorodov on 24.06.2021.
//

import Foundation

typealias ResultBlock<T> = (Result<T, Error>, PaginationLinks?) -> Void

typealias PhotoResult = ResultBlock<PhotoModel>
typealias PhotosResult = ResultBlock<[PhotoModel]>
typealias CollectionsResult = ResultBlock<[CollectionModel]>
typealias SearchPhotosResult = ResultBlock<SearchPhotosModel>
typealias SearchCollectionsResult = ResultBlock<SearchCollectionsModel>

typealias PaginationLinks = [RelationLinkType: URL?]
