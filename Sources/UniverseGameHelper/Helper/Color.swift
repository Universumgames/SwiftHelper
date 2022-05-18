//
//  File.swift
//
//
//  Created by Tom Arlt on 18.05.22.
//

import Foundation
import SwiftUI

public extension Color {
    var components: (red: Int, green: Int, blue: Int, opacity: Int) {
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

        return (Int(r) * 255, Int(g) * 255, Int(b) * 255, Int(o) * 255)
    }

    static func fromHex(hexString: String) -> Color {
        let p1 = hexString.substring(0, 2)
        let p2 = hexString.substring(2, 4)
        let p3 = hexString.substring(4, 6)
        let r = Double(p1.asHexToInt()) / 255
        let g = Double(p2.asHexToInt()) / 255
        let b = Double(p3.asHexToInt()) / 255
        return Color(red: r, green: g, blue: b)
    }

    func toHex() -> String {
        return String.hexFromInt(number: cgColor?.components[0]) +
            String.hexFromInt(number: cgColor?.components[1]) +
            String.hexFromInt(number: cgColor?.components[2])
    }
}
