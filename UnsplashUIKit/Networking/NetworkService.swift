//
//  NetworkService.swift
//  UnsplashUIKit
//
//  Created by User on 03.01.2021.
//

import UIKit

typealias PhotoResult = (Result<Photo, Error>) -> Void
typealias PhotosResult = (Result<[Photo], Error>) -> Void
typealias CollectionsResult = (Result<[Collection], Error>) -> Void

protocol NetworkServiceProtocol {
    /// Переменная, в которой хранится ключ доступа.
    static var accessKey: String { get set }
    
    func getRandomPhoto(completion: @escaping PhotoResult)
    
    func getCollections(completion: @escaping CollectionsResult)
    
    func getCollectionPhotos(id: String, completion: @escaping PhotosResult)
    
    func getImage(fromURL url: URL) -> UIImage?
}

final class NetworkService: NetworkServiceProtocol {
        
    static var accessKey = "_MW7r-0GgxY30SvUHXccHkJUytRpTZNZz1Ty6nPzzvA"
    
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
    
    func getRandomPhoto(completion: @escaping PhotoResult) {
        guard let url = urlService.getURL(forPath: PhotosPath.getRandomPhoto) else { return }

        let request = requestService.request(url: url, httpMethod: .get)
                
        dataTaskService.dataTask(request: request, completion: completion)
    }
    
    func getCollections(completion: @escaping CollectionsResult) {
        guard let url = urlService.getURL(forPath: CollectionsPath.listCollections) else { return }

        let request = requestService.request(url: url, httpMethod: .get)
                
        dataTaskService.dataTask(request: request, completion: completion)
    }
    
    func getCollectionPhotos(id: String, completion: @escaping PhotosResult) {
        guard let url = urlService.getURL(forPath: CollectionsPath.listCollections + "/\(id)/photos") else { return }

        let request = requestService.request(url: url, httpMethod: .get)
                
        dataTaskService.dataTask(request: request, completion: completion)
    }
    
    func getImage(fromURL url: URL) -> UIImage? {
        guard let imageData = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: imageData)
    }
}
