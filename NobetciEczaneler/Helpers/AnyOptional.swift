//
//  AnyOptional.swift
//  NobetciEczaneler
//
//  Created by aykut ipek on 22.08.2024.
//

import Foundation

// AnyOptional protocol to make nil checks easier.
public protocol AnyOptional {
    var isNil: Bool { get }
    var isNotNil: Bool { get }
}

// MARK: - Optional + AnyOptional

// Optional Extension to detect nil values.
extension Optional: AnyOptional {
    public var isNil: Bool { self == nil }
    
    public var isNotNil: Bool { self != nil }
}
