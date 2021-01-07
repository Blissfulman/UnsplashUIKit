//
//  NetworkService.swift
//  UnsplashUIKit
//
//  Created by User on 03.01.2021.
//

import UIKit

typealias PhotoResult = (Result<PhotoModel, Error>) -> Void
typealias PhotosResult = (Result<[PhotoModel], Error>) -> Void
typealias CollectionsResult = (Result<[CollectionModel], Error>) -> Void
typealias SearchPhotosResult = (Result<SearchPhotosModel, Error>) -> Void

protocol NetworkServiceProtocol {
    
    func fetchRandomPhotos(count: Int, completion: @escaping PhotosResult)
    
    func fetchCollections(completion: @escaping CollectionsResult)
    
//    func getCollectionPhotos(id: String, completion: @escaping PhotosResult)
    func fetchCollectionPhotos(url: URL, completion: @escaping PhotosResult)
    
    func searchPhotos(query: String, orderBy: String, completion: @escaping SearchPhotosResult)
}

final class NetworkService: NetworkServiceProtocol {
    
    private let urlService: URLServiceProtocol
    private let requestService: RequestServiceProtocol
    private let dataTaskService: DataTaskServiceProtocol
    
    init(urlService: URLServiceProtocol = URLService(),
         requestService: RequestServiceProtocol = RequestService(),
         dataTaskService: DataTaskServiceProtocol = DataTaskService()) {
        self.urlService = urlService
        self.requestService = requestService
        self.dataTaskService = dataTaskService
    }
    
    func fetchRandomPhotos(count: Int, completion: @escaping PhotosResult) {
        guard let url = urlService.getURL(forPath: PhotosPath.randomPhotos,
                                          count: count) else { return }

        let request = requestService.request(url: url, httpMethod: .get)
                
        dataTaskService.dataTask(request: request, completion: completion)
    }
    
    func fetchCollections(completion: @escaping CollectionsResult) {
        guard let url = urlService.getURL(forPath: CollectionsPath.listCollections,
                                          count: 30) else { return }

        let request = requestService.request(url: url, httpMethod: .get)
                
        dataTaskService.dataTask(request: request, completion: completion)
    }
    
//    func getCollectionPhotos(id: String, completion: @escaping PhotosResult) {
//        guard let url = urlService.getURL(forPath: CollectionsPath.listCollections + "/\(id)/photos",
//                                          count: 30) else { return }
//
//        let request = requestService.request(url: url, httpMethod: .get)
//
//        dataTaskService.dataTask(request: request, completion: completion)
//    }
    
    func fetchCollectionPhotos(url: URL, completion: @escaping PhotosResult) {
        guard let url = urlService.getURL(forURL: url, count: 30) else { return }

        let request = requestService.request(url: url, httpMethod: .get)
                
        dataTaskService.dataTask(request: request, completion: completion)
    }
    
    func searchPhotos(query: String, orderBy: String, completion: @escaping SearchPhotosResult) {
        guard let url = urlService.getURL(forPath: SearchPath.searchPhotos,
                                          query: query,
                                          orderBy: orderBy,
                                          count: 30) else { return }

        let request = requestService.request(url: url, httpMethod: .get)
                
        dataTaskService.dataTask(request: request, completion: completion)
    }
}
