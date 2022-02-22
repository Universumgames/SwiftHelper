//
//  Graph.swift
//  Moody
//
//  Created by Tom Arlt on 19.01.22.
//

import Foundation
import SwiftUI

@available(iOS 13.0, *)
public class Graph {
    /**
     points: Array of normalized grpah points, values are sorted internally (first value x coordinate (0 left, 1 right), second value y coordinate (0 bottom, 1 top)
     */
    static func integralPath(points: [Double: Double], width: CGFloat, height: CGFloat, complicated: Bool = false) -> Path {
        let bezierOffest = CGFloat(Double(width) / Double(points.count))

        let sorted = points.sorted(by: { $0.key < $1.key })
        return Path { path in
            var old = normailzedCoordinateToPathPoint(0, sorted.first?.value ?? 0, width, height)
            path.move(to: old)
            for (key, value) in sorted {
                let p = normailzedCoordinateToPathPoint(key, value, width, height)
                let offset1 = bezierOffest
                let offset2 = bezierOffest
                // path.addLine(to: p)
                path.addCurve(to: p, control1: CGPoint(x: old.x + offset1, y: old.y), control2: CGPoint(x: p.x - offset2, y: p.y))
                old = p
            }
            // path.addLine(to: normailzedCoordinateToPathPoint(1, sorted.last?.value ?? 0, width, height))
            let endStop = normailzedCoordinateToPathPoint(1, sorted.last?.value ?? 0, width, height)
            path.addCurve(to: endStop, control1: CGPoint(x: old.x + bezierOffest, y: old.y), control2: CGPoint(x: endStop.x - bezierOffest, y: endStop.y))
            path.addLine(to: CGPoint(x: width, y: height))
            path.addLine(to: CGPoint(x: 0, y: height))
            path.closeSubpath()
        }
    }

    static func linePath(points: [Double: Double], width: CGFloat, height: CGFloat, complicated: Bool = false) -> Path {
        let bezierOffest = CGFloat(Double(width) / Double(points.count))

        let sorted = points.sorted(by: { $0.key < $1.key })
        return Path { path in
            var old = normailzedCoordinateToPathPoint(0, sorted.first?.value ?? 0, width, height)
            path.move(to: old)
            for (key, value) in sorted {
                let p = normailzedCoordinateToPathPoint(key, value, width, height)
                let offset1 = bezierOffest
                let offset2 = bezierOffest
                // path.addLine(to: p)
                path.addCurve(to: p, control1: CGPoint(x: old.x + offset1, y: old.y), control2: CGPoint(x: p.x - offset2, y: p.y))
                old = p
            }
            // path.addLine(to: normailzedCoordinateToPathPoint(1, sorted.last?.value ?? 0, width, height))
            let endStop = normailzedCoordinateToPathPoint(1, sorted.last?.value ?? 0, width, height)
            path.addCurve(to: endStop, control1: CGPoint(x: old.x + bezierOffest, y: old.y), control2: CGPoint(x: endStop.x - bezierOffest, y: endStop.y))
        }
    }

    static func trendPath(line: Line, width: CGFloat, height: CGFloat) -> Path {
        return Path { path in
            path.move(to: normailzedCoordinateToPathPoint(0, line.b, width, height))
            path.addLine(to: normailzedCoordinateToPathPoint(1, line.m + line.b, width, height))
        }
    }

    private static func normailzedCoordinateToPathPoint(_ x: Double, _ y: Double, _ width: CGFloat, _ height: CGFloat) -> CGPoint {
        CGPoint(x: Double(x.isNaN ? 0 : x) * width, y: (1 - Double(y.isNaN ? 0 : y)) * height)
    }

    /**
     Used formula: y= mx + b
     */
    struct Line {
        var m: Double
        var b: Double
    }

    // equation source: https://classroom.synonym.com/calculate-trendline-2709.html
    static func trendLine(points: [Double: Double]) -> Line {
        let sorted = points.sorted(by: { $0.key < $1.key })
        var a = 0.0
        var keySum = 0.0
        var valueSum = 0.0
        var sqKeySum = 0.0

        for (key, value) in sorted {
            keySum += key
            valueSum += value
            sqKeySum = key * key
            a += key * value
        }
        a *= Double(sorted.count)
        let b = keySum * valueSum
        let c = Double(sorted.count) * sqKeySum
        let d = keySum * keySum
        let m = (a - b) / (c - d)
        let e = valueSum
        let f = m * keySum
        let b2 = (e - f) / Double(sorted.count)

        return Line(m: m, b: b2)
    }
}
