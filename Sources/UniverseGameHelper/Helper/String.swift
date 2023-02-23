//
//  String.swift
//  Moody
//
//  Created by Tom Arlt on 01.02.22.
//

import Foundation

public extension String {
    var wordCount: Int {
        return split { $0 == " " || $0.isNewline }.count
    }

    var characterCount: Int {
        return count
    }

    /// stringToFind must be at least 1 character.
    func countInstances(of stringToFind: String) -> Int {
        assert(!stringToFind.isEmpty)
        var count = 0
        var searchRange: Range<String.Index>?
        while let foundRange = range(of: stringToFind, options: [], range: searchRange) {
            count += 1
            searchRange = Range(uncheckedBounds: (lower: foundRange.upperBound, upper: endIndex))
        }
        return count
    }

    func markdownToAttributed() -> AttributedString {
        do {
            return try AttributedString(markdown: self) /// convert to AttributedString
        } catch {
            return AttributedString("Error parsing markdown: \(error)")
        }
    }

    func substring(_ startIndex: Int, _ endIndex: Int) -> String {
        let start = self.index(self.startIndex, offsetBy: startIndex)
        let end = self.index(self.startIndex, offsetBy: endIndex)
        let range = start..<end

        let mySubstring = self[range]
        return String(mySubstring)
    }
    
    func test(_ regex: String) -> Bool {
        do {
            let reg = try NSRegularExpression(pattern: regex)
            let range = NSRange(location: 0, length: count)
            return reg.firstMatch(in: self, options: [], range: range) != nil
        } catch {
            return false
        }
    }

    func percentEncoded() -> String {
        return addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
    }

    var localized: String {
        return NSLocalizedString(self, comment: "")
    }

    func replace(_ regex: String, with: String) -> String {
        if #available(iOS 16.0, *) {
            return replacing(regex, with: with)
        } else {
            return replacingOccurrences(of: " ", with: "")
        }
    }

    // javascript equivalent
    func toLowerCase() -> String {
        return lowercased()
    }
    
    // javascript equivalent
    func includes(_ other: any StringProtocol) -> Bool{
        return contains(other)
    }
    
    
}
