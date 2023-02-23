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
    
    mutating func move(from oldIndex: Index, to newIndex: Index) {
        // Don't work for free and use swap when indices are next to each other - this
        // won't rebuild array and will be super efficient.
        if oldIndex == newIndex { return }
        if abs(newIndex - oldIndex) == 1 { return swapAt(oldIndex, newIndex) }
        insert(remove(at: oldIndex), at: newIndex)
    }

    func saveElement(_ index: Int) -> Array.Element? {
        return indices.contains(index) ? self[index] : nil
    }

    func indexIsSet(_ index: Int) -> Bool {
        return indices.contains(index)
    }
}

extension Array where Element: Equatable {
    mutating func move(_ element: Element, to newIndex: Index) {
        if let oldIndex: Int = firstIndex(of: element) { move(from: oldIndex, to: newIndex) }
    }
}
