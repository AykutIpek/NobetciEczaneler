//
//  StringExtensions.swift
//  NobetciEczaneler
//
//  Created by aykut ipek on 22.08.2024.
//

import Foundation
import SwiftUI

extension String {
    /// Returns Dictionary representation of JSON Serializable string.
    public var asDictionary: [String: Any] {
        if let data = data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] ?? [:]
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
        return [:]
    }

    /// Returns attributed string from the original string. So that we could use NSMutableAttributedString Extension via String.
    public var asMutableAttrString: NSMutableAttributedString {
        NSMutableAttributedString(string: self)
    }

    /// Returns whitespace trimmed version of string.
    /// Input = " test string " -> output: "test string"
    public var whitespaceTrimmed: String {
        trimmingCharacters(in: .whitespaces)
    }

    /// Returns whitespace removed version of string
    /// Input = " test string " -> output: "teststring"
    public var stringByRemovingWhitespaces: String {
        components(separatedBy: .whitespaces).joined()
    }

    /// Returns isNotEmpty
    public var isNotEmpty: Bool {
        !isEmpty
    }

    /// Returns isNewLine
    public var isNewLine: Bool {
        !rangeOfCharacter(from: .newlines).isNil
    }

    /// Returns a random alphanumeric string of the given length
    ///
    /// - Parameter count: Length of random string.
    ///
    /// - Returns: Random alphanumeric string of the given length
    public static func random(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map { _ in letters.randomElement().unsafelyUnwrapped })
    }

    /// Finds first index of given character and returns.
    ///
    /// - Parameter char: Character to check for first index.
    ///
    /// - Returns: First index of given character.

    public func firstIndex(of char: Character) -> Int? {
        for (index, currentChar) in enumerated() where currentChar == char {
            return index
        }
        return nil
    }

    /// Finds last index of given character and returns.
    ///
    /// - Parameter char: Character to check for last index.
    ///
    /// - Returns: Last index of given character.

    public func lastIndex(of char: Character) -> Int? {
        var index = -1
        for (currentIndex, currentChar) in enumerated() where currentChar == char {
            index = currentIndex
        }
        return index == -1 ? nil : index
    }

    /// Replaces character for string at index with newChar.
    ///
    /// - Parameter string: String to replace character.
    /// - Parameter index: Index of character to replace.
    /// - Parameter newChar: New character to replace.
    ///
    /// - Returns: String with newChar at given index.

    public func replace(string: String, _ index: Int, _ newChar: Character) -> String {
        var chars = Array(string)
        if chars.count > index {
            chars[index] = newChar
        }
        return String(chars)
    }

    /// Slices string with using lower/higher bounds.
    ///
    /// - Parameter from: Lower bound string of slice.
    /// - Parameter to: Upper bound string of slice.
    ///
    /// - Returns: Sliced String.

    public func slice(from: String, to: String) -> String? {
        (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }

    /// Returns Date representation of String.
    public var asDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: self)
    }

    /// Returns underlined representation of String.
    public var underlined: NSAttributedString {
        let textRange = NSRange(location: 0, length: count)
        let attributedText = NSMutableAttributedString(string: self)
        attributedText.addAttribute(
            NSAttributedString.Key.underlineStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: textRange
        )
        return attributedText
    }

    /// Returns NSAttributedString for String.
    public var basicAttributedString: NSAttributedString {
        NSMutableAttributedString(string: self)
    }

    /// Truncates the string to the specified length number of characters and appends an optional trailing string if longer.
    /// - Parameter length: Desired maximum lengths of a string
    /// - Parameter trailing: A 'String' that will be appended after the truncation.
    ///
    /// - Returns: 'String' object.

    public func trunc(length: Int, trailing: String = "…") -> String {
        (count > length) ? prefix(length) + trailing : self
    }

    public func copyToPasteboard() {
        UIPasteboard.general.string = self
    }

    public var boolValue: Bool {
        switch lowercased() {
        case "true", "t", "yes", "y", "1":
            return true
        default:
            return false
        }
    }

    /// Returns empty string
    public static var empty: String {
        ""
    }

    /// Returns whitespace
    public static var whitespace: String {
        " "
    }
    
    var localized: String {
        NSLocalizedString(self, bundle: .localizedBundle(), comment: "")
    }
    
    func localized(with arguments: CVarArg...) -> String {
        let format = NSLocalizedString(self, comment: "")
        return String(format: format, arguments: arguments)
    }
}
