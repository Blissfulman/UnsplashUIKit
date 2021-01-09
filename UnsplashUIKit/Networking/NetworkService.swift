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
typealias SearchCollectionsResult = (Result<SearchCollectionsModel, Error>) -> Void

protocol NetworkServiceProtocol {
    
    /// Получение случайных фотографий.
    /// - Parameters:
    ///   - count: Количество фотографий в ответе (не более 30).
    ///   - completion: Замыкание, в которое возвращается результат выполнения функции.
    func fetchRandomPhotos(count: Int, completion: @escaping PhotosResult)
    
    /// Получение одной страницы из списка коллекций.
    /// - Parameters:
    ///   - count: Количество коллекций в ответе (не более 30).
    ///   - completion: Замыкание, в которое возвращается результат выполнения функции.
    func fetchCollections(count: Int, completion: @escaping CollectionsResult)
        
    /// Получение фотографий из коллекции.
    /// - Parameters:
    ///   - url: URL коллекции.
    ///   - completion: Замыкание, в которое возвращается результат выполнения функции.
    func fetchCollectionPhotos(url: URL, completion: @escaping PhotosResult)
    
    /// Получение одной страницы результатов поиска фотографий по указанным параметрам.
    /// - Parameters:
    ///   - query: Поисковые запросы.
    ///   - orderBy: Вариант сортировки фотографий. Допустимые значения "latest" и "relevant".
    ///   - completion: Замыкание, в которое возвращается результат выполнения функции.
    func searchPhotos(query: String, orderBy: String, completion: @escaping SearchPhotosResult)
    
    /// Получение одной страницы результатов поиска коллекций по указанным параметрам.
    /// - Parameters:
    ///   - query: Поисковые запросы.
    ///   - orderBy: Вариант сортировки коллекций. Допустимые значения "latest" и "relevant".
    ///   - completion: Замыкание, в которое возвращается результат выполнения функции.
    func searchCollections(query: String, orderBy: String, completion: @escaping SearchCollectionsResult)
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
        guard let url = urlService.getURL(forPath: APIPath.randomPhotos,
                                          count: count) else { return }

        let request = requestService.request(url: url, httpMethod: .get)
                
        dataTaskService.dataTask(request: request, completion: completion)
    }
    
    func fetchCollections(count: Int, completion: @escaping CollectionsResult) {
        guard let url = urlService.getURL(forPath: APIPath.listCollections,
                                          count: count) else { return }

        let request = requestService.request(url: url, httpMethod: .get)
                
        dataTaskService.dataTask(request: request, completion: completion)
    }
    
    func fetchCollectionPhotos(url: URL, completion: @escaping PhotosResult) {
        guard let url = urlService.add(countElements: 30, forURL: url) else { return }

        let request = requestService.request(url: url, httpMethod: .get)
                
        dataTaskService.dataTask(request: request, completion: completion)
    }
    
    func searchPhotos(query: String, orderBy: String, completion: @escaping SearchPhotosResult) {
        guard let url = urlService.getURL(forPath: APIPath.searchPhotos,
                                          query: query,
                                          orderBy: orderBy,
                                          count: 30) else { return }

        let request = requestService.request(url: url, httpMethod: .get)
                
        dataTaskService.dataTask(request: request, completion: completion)
    }
    
    func searchCollections(query: String, orderBy: String, completion: @escaping SearchCollectionsResult) {
        guard let url = urlService.getURL(forPath: APIPath.searchCollections,
                                          query: query,
                                          orderBy: orderBy,
                                          count: 30) else { return }

        let request = requestService.request(url: url, httpMethod: .get)
                
        dataTaskService.dataTask(request: request, completion: completion)
    }

}
