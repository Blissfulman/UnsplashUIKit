//
//  NetworkService.swift
//  UnsplashUIKit
//
//  Created by Evgeny Novgorodov on 03.01.2021.
//

import Foundation

// MARK: - Protocols

protocol NetworkServiceProtocol {
    
    /// Получение случайных фотографий.
    /// - Parameters:
    ///   - count: Количество фотографий в ответе (не более 30).
    ///   - completion: Обработчик завершения, в который возвращается результат выполнения функции.
    func fetchRandomPhotos(count: Int, completion: @escaping PhotosResult)
    
    /// Получение списка коллекций.
    /// - Parameters:
    ///   - count: Количество коллекций в ответе (не более 30).
    ///   - completion: Обработчик завершения, в который возвращается результат выполнения функции.
    func fetchCollections(count: Int, completion: @escaping CollectionsResult)
    
    /// Получение фотографий из коллекции.
    /// - Parameters:
    ///   - id: ID коллекции.
    ///   - completion: Обработчик завершения, в который возвращается результат выполнения функции.
    func fetchCollectionPhotos(id: String, completion: @escaping PhotosResult)
    
    /// Получение результата поиска фотографий по указанным параметрам.
    /// - Parameters:
    ///   - query: Поисковые запросы.
    ///   - orderBy: Вариант сортировки фотографий. Допустимые значения "latest" и "relevant".
    ///   - completion: Обработчик завершения, в который возвращается результат выполнения функции.
    func searchPhotos(query: String, orderBy: String, completion: @escaping SearchPhotosResult)
    
    /// Получение результата поиска коллекций по указанным параметрам.
    /// - Parameters:
    ///   - query: Поисковые запросы.
    ///   - orderBy: Вариант сортировки коллекций. Допустимые значения "latest" и "relevant".
    ///   - completion: Обработчик завершения, в который возвращается результат выполнения функции.
    func searchCollections(query: String, orderBy: String, completion: @escaping SearchCollectionsResult)
}

final class NetworkService: NetworkServiceProtocol {
    
    private let requestService: RequestServiceProtocol = RequestService()
    private let dataTaskService: DataTaskServiceProtocol = DataTaskService()
    
    func fetchRandomPhotos(count: Int, completion: @escaping PhotosResult) {
        guard let url = APIURL.randomPhotos(count: count).url else { return }
        
        let request = requestService.getRequest(url: url, httpMethod: .get)
        dataTaskService.dataTask(request: request, completion: completion)
    }
    
    func fetchCollections(count: Int, completion: @escaping CollectionsResult) {
        guard let url = APIURL.listCollections(count: count).url else { return }
        
        let request = requestService.getRequest(url: url, httpMethod: .get)
        dataTaskService.dataTask(request: request, completion: completion)
    }
    
    func fetchCollectionPhotos(id: String, completion: @escaping PhotosResult) {
        guard let url = APIURL.collectionPhotos(id: id,
                                                count: APIConstant.itemsPerPage).url else { return }
        
        let request = requestService.getRequest(url: url, httpMethod: .get)
        dataTaskService.dataTask(request: request, completion: completion)
    }
    
    func searchPhotos(query: String, orderBy: String, completion: @escaping SearchPhotosResult) {
        guard let url = APIURL.searchPhotos(query: query,
                                            orderBy: orderBy,
                                            count: APIConstant.itemsPerPage).url else { return }
        
        let request = requestService.getRequest(url: url, httpMethod: .get)
        dataTaskService.dataTask(request: request, completion: completion)
    }
    
    func searchCollections(query: String, orderBy: String, completion: @escaping SearchCollectionsResult) {
        guard let url = APIURL.searchCollections(query: query,
                                                 orderBy: orderBy,
                                                 count: APIConstant.itemsPerPage).url else { return }
        
        let request = requestService.getRequest(url: url, httpMethod: .get)
        dataTaskService.dataTask(request: request, completion: completion)
    }
}
