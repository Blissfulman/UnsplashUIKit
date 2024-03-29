//
//  ServerError.swift
//  UnsplashUIKit
//
//  Created by Evgeny Novgorodov on 02.01.2021.
//

import Foundation

enum ServerError: Int, Error, LocalizedError {
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case somethingElse = 500
    case somethingElse2 = 503
    case unknownError = 0
    
    var errorDescription: String {
        switch self {
        case .badRequest:
            return "The request was unacceptable, often due to missing a required parameter"
        case .unauthorized:
            return "Invalid access token"
        case .forbidden:
            return "Missing permissions to perform request"
        case .notFound:
            return "The requested resource doesn’t exist"
        case .somethingElse, .somethingElse2:
            return "Something went wrong on our end"
        case .unknownError:
            return "Unknown error"
        }
    }
}
