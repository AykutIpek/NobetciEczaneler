//
//  OptionalExtensions.swift
//  NobetciEczaneler
//
//  Created by aykut ipek on 22.08.2024.
//

import Foundation


// Extension of Optional. Adds following capability to String; Null/Nil handling in an elegant way.
extension Swift.Optional where Wrapped == String {
    public var orEmptyString: String {
        if let unwrappedString = self {
            return unwrappedString
        }
        return ""
    }
    
    public func or(_ text: String) -> String {
        guard let str = self else {
            return text
        }
        return str
    }
    
    public func or(optionalString: String?) -> String? {
        guard let str = self else {
            return optionalString
        }
        return str
    }
    
    public var isNullOrEmpty: Bool {
        if self == Optional.none {
            return true
        }
        if let value = self {
            return value.isEmpty
        }
        return false
    }
    
    public var isNotNullOrEmpty: Bool {
        !isNullOrEmpty
    }
}
/// Extension of Optional. Adds following capability to Double; Null/Nil handling in an elegant way.
extension Swift.Optional where Wrapped == Double {
    public var orZero: Double {
        if let unwrappedDouble = self {
            return unwrappedDouble
        }
        return 0
    }
    
    public func or(_ value: Double) -> Double {
        guard let dbl = self else {
            return value
        }
        return dbl
    }
}
/// Extension of Optional. Adds following capability to UInt; Null/Nil handling in an elegant way.
extension Swift.Optional where Wrapped == UInt {
    public var orZero: UInt {
        if let unwrappedDouble = self {
            return unwrappedDouble
        }
        return 0
    }
    
    public func or(_ value: UInt) -> UInt {
        guard let int = self else {
            return value
        }
        return int
    }
}
/// Extension of Optional. Adds following capability to Int; Null/Nil handling in an elegant way.
extension Swift.Optional where Wrapped == Int {
    public var orZero: Int {
        if let unwrappedInt = self {
            return unwrappedInt
        }
        return 0
    }
}
/// Extension of Optional. Adds following capability to Bool; Null/Nil handling in an elegant way.
extension Swift.Optional where Wrapped == Bool {
    public var orFalse: Bool {
        if let unwrappedBool = self {
            return unwrappedBool
        }
        return false
    }
    
    public var orTrue: Bool {
        if let unwrappedBool = self {
            return unwrappedBool
        }
        return true
    }
}
/// Extension of Optional. Adds following capability to CGPoint; Null/Nil handling in an elegant way.
extension Swift.Optional where Wrapped == CGPoint {
    public var orZero: CGPoint {
        if let unwrappedCGPoint = self {
            return unwrappedCGPoint
        }
        return .zero
    }
}
extension Swift.Optional where Wrapped == CGFloat {
    public var orZero: CGFloat {
        if let unwrappedCGPoint = self {
            return unwrappedCGPoint
        }
        return .zero
    }
}
extension Swift.Optional where Wrapped == Decimal {
    public var orZero: Decimal {
        if let unwrappedDecimal = self {
            return unwrappedDecimal
        }
        return .zero
    }
}
extension Swift.Optional where Wrapped: EmptyValuable {
    /// Returns an empty of`Wrapped` type if self is nil, otherwise it returns unwrapped value.
    public var orEmpty: Wrapped {
        guard let self = self else {
            return Wrapped.emptyValue
        }
        return self
    }
}
extension Swift.Optional where Wrapped == NSAttributedString {
    public var orEmptyAttributedString: NSAttributedString {
        if let unwrappedString = self {
            return unwrappedString
        }
        return NSAttributedString(string: "")
    }
}

public protocol EmptyValuable {
    static var emptyValue: Self { get }
}
