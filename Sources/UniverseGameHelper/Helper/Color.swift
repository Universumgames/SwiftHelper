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
        let values = UIColor(self).cgColor.components
        var outputR: Int = 0
        var outputG: Int = 0
        var outputB: Int = 0
        var outputA: Int = 1

        switch values!.count {
        case 1:
            outputR = Int(values![0] * 255)
            outputG = Int(values![0] * 255)
            outputB = Int(values![0] * 255)
            outputA = 1
        case 2:
            outputR = Int(values![0] * 255)
            outputG = Int(values![0] * 255)
            outputB = Int(values![0] * 255)
            outputA = Int(values![1] * 255)
        case 3:
            outputR = Int(values![0] * 255)
            outputG = Int(values![1] * 255)
            outputB = Int(values![2] * 255)
            outputA = 1
        case 4:
            outputR = Int(values![0] * 255)
            outputG = Int(values![1] * 255)
            outputB = Int(values![2] * 255)
            outputA = Int(values![3] * 255)
        default:
            break
        }

        return (outputR, outputG, outputB, outputA)
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
        return String.hexFromInt(number: components.red) +
            String.hexFromInt(number: components.green) +
            String.hexFromInt(number: components.blue)
    }
}
