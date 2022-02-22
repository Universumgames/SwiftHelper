//
//  Binding.swift
//  Moody
//
//  Created by Tom Arlt on 26.01.22.
//

import Foundation
import SwiftUI

@available(iOS 13.0, *)
public extension Binding where Value: Equatable {
    init(_ source: Binding<Value?>, replacingNilWith nilProxy: Value) {
        self.init(
            get: { source.wrappedValue ?? nilProxy },
            set: { newValue in
                if newValue == nilProxy {
                    source.wrappedValue = nil
                }
                else {
                    source.wrappedValue = newValue
                }
        })
    }
}
