//
//  File.swift
//
//
//  Created by Tom Arlt on 18.05.22.
//

import Foundation

extension String {
    static func hexFromInt(number: Int) -> String {
        return String(format: "%02X", number)
    }

    func asHexToInt() -> Int {
        return Int(self, radix: 16) ?? 0
    }
}
