//
//  NetworkError.swift
//  NobetciEczaneler
//
//  Created by aykut ipek on 19.08.2024.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case decodingFailed
    case serverError(statusCode: Int)
    case custom(errorMessage: String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .decodingFailed:
            return "Failed to decode the response."
        case .serverError(let statusCode):
            return "Server returned an error with status code: \(statusCode)."
        case .custom(let errorMessage):
            return errorMessage
        }
    }
}
