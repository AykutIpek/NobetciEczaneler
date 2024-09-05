//
//  Configuration.swift
//  NobetciEczaneler
//
//  Created by aykut ipek on 5.09.2024.
//

import Foundation


struct Configuration {
    enum ConfigurationError: Error {
        case missingKey, invalidValue
    }

    static func value<T>(for key: String) throws -> T {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) as? T else {
            throw ConfigurationError.missingKey
        }
        return value
    }
}
