//
//  Transition.swift
//  Moody
//
//  Created by Tom Arlt on 25.01.22.
//

import Foundation
import SwiftUI

@available(iOS 13.0, *)
public extension AnyTransition{
    static var moveDown: AnyTransition{
        .move(edge: .top).combined(with: .opacity)
    }
}
