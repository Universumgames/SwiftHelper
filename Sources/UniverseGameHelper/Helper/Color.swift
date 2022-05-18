//
//  File.swift
//
//
//  Created by Tom Arlt on 18.05.22.
//

import Foundation
import SwiftUI

public extension Color {
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, opacity: CGFloat) {
        #if canImport(UIKit)
            typealias NativeColor = UIColor
        #elseif canImport(AppKit)
            typealias NativeColor = NSColor
        #endif

        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var o: CGFloat = 0

        guard NativeColor(self).getRed(&r, green: &g, blue: &b, alpha: &o) else {
            // You can handle the failure here as you want
            return (0, 0, 0, 0)
        }

        return (r, g, b, o)
    }

    static func fromHex(hexString: String) -> Color {
        let p1 = hexString.substring(0, 2)
        let p2 = hexString.substring(2, 4)
        let p3 = hexString.substring(4, 6)
        return Color(red: Double(p1.asHexToInt()), green: Double(p2.asHexToInt()), blue: Double(p3.asHexToInt()))
    }

    func toHex() -> String {
        return String.hexFromInt(number: Int(components.red)) +
            String.hexFromInt(number: Int(components.green)) +
            String.hexFromInt(number: Int(components.blue))
    }
}
