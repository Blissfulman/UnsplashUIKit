//
//  DataTaskService.swift
//  UnsplashUIKit
//
//  Created by Evgeny Novgorodov on 03.01.2021.
//

import Foundation

protocol DataTaskServiceProtocol {
    
    /// Выполнение URLSessionDataTask с переданным запросом.
    /// - Parameters:
    ///   - request: Требуемый для выполнения запрос.
    ///   - completion: Обработчик завершения, вызываемый после получения данных.
    func dataTask<T: Decodable>(request: URLRequest, completion: @escaping ResultBlock<T>)
}

final class DataTaskService: DataTaskServiceProtocol {
    
    // MARK: - Public methods
    
    func dataTask<T: Decodable>(request: URLRequest, completion: @escaping ResultBlock<T>) {
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(error), nil)
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  let data = data else {
                print("Receive HTTP response error")
                return
            }
            
            guard ServerErrorHandler.handle(httpResponse, completion: completion) else { return }
            print(httpResponse.statusCode, request.url?.path ?? "")
            
            let links = self.getPaginationLinks(from: httpResponse)
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatter.serverDateFormatter)
            
            do {
                let result = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(result), links)
                }
            } catch {
                completion(.failure(error), nil)
            }
        }.resume()
    }
    
    // MARK: - Private methods
    
    private func getPaginationLinks(from httpResponse: HTTPURLResponse) -> PaginationLinks? {
        guard let stringLinks = httpResponse.value(forHTTPHeaderField: "Link") else {
            return nil
        }
        return stringLinks.decodeToPaginationURLs(regexPattern: APIConstant.linksRegexPattern)
    }
}
