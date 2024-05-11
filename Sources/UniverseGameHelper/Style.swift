//
//  Style.swift
//
//
//  Created by Tom Arlt on 17.03.24.
//

import Foundation
import SwiftUI

public protocol StylingDefinition {
    var defaultCornerRadius: CGFloat { get }

    associatedtype colorDef: ColorDefinition
    var colors: colorDef { get }
}

public protocol ColorDefinition {
    var background: Color { get }
    var secondaryBackground: Color { get }
}

public class DefaultStylingDefinition: StylingDefinition {
    public init(defaultCornerRadius: CGFloat = 20, colors: DefaultColorDefinition = DefaultColorDefinition()) {
        self.defaultCornerRadius = defaultCornerRadius
        self.colors = colors
    }

    public var defaultCornerRadius: CGFloat

    public var colors: DefaultColorDefinition

    public class DefaultColorDefinition: ColorDefinition {
        public init(background: Color = Color.red, secondaryBackground: Color = Color.orange) {
            self.background = background
            self.secondaryBackground = secondaryBackground
        }
        public var background: Color
        public var secondaryBackground: Color
    }
}

public struct StylingEnvironmentKey: EnvironmentKey {
    public static var defaultValue: any StylingDefinition = DefaultStylingDefinition()
}

public extension EnvironmentValues {
    var styling: any StylingDefinition {
        get { self[StylingEnvironmentKey.self] }
        set { self[StylingEnvironmentKey.self] = newValue }
    }
}

public extension View {
    func styling(_ styling: any StylingDefinition) -> some View {
        environment(\.styling, styling)
    }
}
