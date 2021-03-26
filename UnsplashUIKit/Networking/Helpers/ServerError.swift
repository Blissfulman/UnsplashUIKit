//
//  ServerError.swift
//  UnsplashUIKit
//
//  Created by Evgeny Novgorodov on 02.01.2021.
//

enum ServerError: Error {
    case badRequest     // 400
    case unauthorized   // 401
    case forbidden      // 403
    case notFound       // 404
    case somethingElse  // 500, 503
    case unknownError
    
    var localizedDescription: String {
        switch self {
        case .badRequest:
            return "The request was unacceptable, often due to missing a required parameter"
        case .unauthorized:
            return "Invalid access token"
        case .forbidden:
            return "Missing permissions to perform request"
        case .notFound:
            return "The requested resource doesn’t exist"
        case .somethingElse:
            return "Something went wrong on our end"
        case .unknownError:
            return "Unknown error"
        }
    }
}
