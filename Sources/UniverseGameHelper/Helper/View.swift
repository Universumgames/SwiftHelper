//
//  File.swift
//  
//
//  Created by Tom Arlt on 23.02.23.
//

import Foundation
import SwiftUI

public struct Sticky: ViewModifier {
    var axis: StickyAxis
    var coordinateSpace: String
    @State private var frame: CGRect = .zero

    var isStickingY: Bool {
        frame.minY < 0
    }

    var isStickingX: Bool {
        frame.minX < 0
    }

    var zIndex: CGFloat {
        if axis == .xyAxis {
            return .infinity
        }
        if isStickingX || isStickingY {
            return .greatestFiniteMagnitude
        }
        return 0
    }

    public func body(content: Content) -> some View {
        content
            .offset(x: isStickingX && (axis == .xAxis || axis == .xyAxis) ? -frame.minX : 0,
                    y: isStickingY && (axis == .yAxis || axis == .xyAxis) ? -frame.minY : 0)
            .zIndex(zIndex)
            .overlay(GeometryReader { proxy in
                let f = proxy.frame(in: .named(coordinateSpace))
                Color.clear
                    .onAppear { frame = f }
                    .onChange(of: f) { frame = $0 }
            })
            
    }
}

public enum StickyAxis {
    case yAxis, xAxis, xyAxis
}

public extension View {
    func sticky(_ axis: StickyAxis = .yAxis, coordinateSpace space: String = "container") -> some View {
        modifier(Sticky(axis: axis, coordinateSpace: space))
    }
    
    func hapticSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    func hapticError(){
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
}

public extension TupleView {
    var getViews: [AnyView] {
        makeArray(from: value)
    }

    private struct GenericView {
        let body: Any

        var anyView: AnyView? {
            AnyView(_fromValue: body)
        }
    }

    private func makeArray<Tuple>(from tuple: Tuple) -> [AnyView] {
        func convert(child: Mirror.Child) -> AnyView? {
            withUnsafeBytes(of: child.value) { ptr -> AnyView? in
                let binded = ptr.bindMemory(to: GenericView.self)
                return binded.first?.anyView
            }
        }

        let tupleMirror = Mirror(reflecting: tuple)
        return tupleMirror.children.compactMap(convert)
    }
}
