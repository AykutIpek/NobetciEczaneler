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
            return LocalizableString.invalidURL.rawValue.localized
        case .decodingFailed:
            return LocalizableString.decodingFailed.rawValue.localized
        case .serverError(let statusCode):
            return "\(LocalizableString.serverError.rawValue.localized + statusCode.description)"
        case .custom(let errorMessage):
            return errorMessage
        }
    }
}
