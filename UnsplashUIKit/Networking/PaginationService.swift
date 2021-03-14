//
//  PaginationService.swift
//  UnsplashUIKit
//
//  Created by Evgeny Novgorodov on 11.01.2021.
//

import Foundation

protocol PaginationServiceProtocol {
    
    /// Получение очередной страницы фотографий коллекции по URL.
    /// - Parameters:
    ///   - url: URL запроса.
    ///   - completion: Обработчик завершения, в который возвращается результат выполнения функции.
    func fetchCollectionPhotos(url: URL, completion: @escaping PhotosResult)
    
    /// Получение очередной страницы результата поиска коллекций по URL.
    /// - Parameters:
    ///   - url: URL запроса.
    ///   - completion: Обработчик завершения, в который возвращается результат выполнения функции.
    func searchCollections(url: URL, completion: @escaping SearchCollectionsResult)
    
    /// Получение очередной страницы результата поиска фотографий по URL.
    /// - Parameters:
    ///   - url: URL запроса.
    ///   - completion: Обработчик завершения, в который возвращается результат выполнения функции.
    func searchPhotos(url: URL, completion: @escaping SearchPhotosResult)
}
final class PaginationService: PaginationServiceProtocol {
    
    private let requestService: RequestServiceProtocol
    private let dataTaskService: DataTaskServiceProtocol
    
    init(requestService: RequestServiceProtocol = RequestService(),
         dataTaskService: DataTaskServiceProtocol = DataTaskService()) {
        self.requestService = requestService
        self.dataTaskService = dataTaskService
    }
    
    func fetchCollectionPhotos(url: URL, completion: @escaping PhotosResult) {
        let request = requestService.getRequest(url: url, httpMethod: .get)
                
        dataTaskService.dataTask(request: request, completion: completion)
    }
    
    func searchCollections(url: URL, completion: @escaping SearchCollectionsResult) {
        let request = requestService.getRequest(url: url, httpMethod: .get)
                
        dataTaskService.dataTask(request: request, completion: completion)
    }
    
    func searchPhotos(url: URL, completion: @escaping SearchPhotosResult) {
        let request = requestService.getRequest(url: url, httpMethod: .get)
                
        dataTaskService.dataTask(request: request, completion: completion)
    }
}
