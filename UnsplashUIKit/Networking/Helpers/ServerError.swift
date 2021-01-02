//
//  ServerError.swift
//  UnsplashUIKit
//
//  Created by User on 02.01.2021.
//

import Foundation

enum ServerError: String, Error {
    case badRequest = "The request was unacceptable, often due to missing a required parameter" // 400
    case unauthorized = "Invalid Access Token" // 401
    case forbidden = "Missing permissions to perform request" // 403
    case notFound = "The requested resource doesn’t exist" // 404
    case somethingElse = "Something went wrong on our end" // 500, 503
    case unknownError = "Unknown error"
}
