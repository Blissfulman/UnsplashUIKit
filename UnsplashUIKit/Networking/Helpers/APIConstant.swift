//
//  APIConstant.swift
//  UnsplashUIKit
//
//  Created by User on 05.01.2021.
//

enum APIConstant {
    
    /// Базовый URL API.
    static let baseURL = "https://api.unsplash.com"
    
    /// Ключ доступа к API.
    static let accessKey = "_MW7r-0GgxY30SvUHXccHkJUytRpTZNZz1Ty6nPzzvA"
    
    /// Количество загружаемых элементов на одной странице.
    static let itemsPerPage = 30
    
    /// Regex pattern для декодирования ссылок пагинации в хедере ответа от сервера.
    static let linksRegexPattern = #"\<(\S*)\>; rel=\"(\S*)\""#
}
