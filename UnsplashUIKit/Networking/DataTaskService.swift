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
    
    func dataTask<T: Decodable>(request: URLRequest, completion: @escaping ResultBlock<T>) {
        
        URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            
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
            
            guard self.handleServerError(httpResponse, completion: completion) else { return }
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
    
    private func getPaginationLinks(from httpResponse: HTTPURLResponse) -> PaginationLinks? {
        
        guard let stringLinks = httpResponse.value(forHTTPHeaderField: "Link") else {
            return nil
        }
        return stringLinks.decodeToPaginationURLs(regexPattern: APIConstant.linksRegexPattern)
    }
    
    /// Обработка ошибок сервера, по статус-коду в response.
    /// - Parameters:
    ///   - response: Ответ от сервера.
    ///   - completion: Замыкание, в которое возвращается ошибка от сервера. Вызывается, если в ответе от сервера статус-код не равен 200.
    /// - Returns: Возвращает true если в ответ от сервера пришёл статус-код 200, в иных случаях возвращает false.
    private func handleServerError<T>(_ response: HTTPURLResponse,
                                      completion: ResultBlock<T>) -> Bool {
        
        if response.statusCode == 200 {
            return true
        } else {
            let serverError: ServerError
            
            switch response.statusCode {
            case 400: serverError = .badRequest
            case 401: serverError = .unauthorized
            case 403: serverError = .forbidden
            case 404: serverError = .notFound
            case 500, 503: serverError = .somethingElse
            default: serverError = .unknownError
            }
            completion(.failure(serverError), nil)
            
            return false
        }
    }
}
