//
//  Array.swift
//  Moody
//
//  Created by Tom Arlt on 23.01.22.
//

import Foundation

public extension Array {
    func shifted(by shiftAmount: Int) -> Array<Element> {
        // 1
        guard count > 0, (shiftAmount % count) != 0 else { return self }

        // 2
        let moduloShiftAmount = shiftAmount % count
        let negativeShift = shiftAmount < 0
        let effectiveShiftAmount = negativeShift ? moduloShiftAmount + count : moduloShiftAmount

        // 3
        let shift: (Int) -> Int = { $0 + effectiveShiftAmount >= self.count ? $0 + effectiveShiftAmount - self.count : $0 + effectiveShiftAmount }

        // 4
        return enumerated().sorted(by: { shift($0.offset) < shift($1.offset) }).map { $0.element }
    }
}
