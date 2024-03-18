//
//  Style.swift
//
//
//  Created by Tom Arlt on 17.03.24.
//

import Foundation
import SwiftUI

public protocol StylingDefinition: ObservableObject {
    var defaultCornerRadius: CGFloat { get }

    associatedtype colorDef: ColorDefinition
    var colors: colorDef { get }
}

public protocol ColorDefinition: ObservableObject {
    var background: Color { get }
    var secondaryBackground: Color { get }
} 


public class DefaultStylingDefinition: StylingDefinition {
    public init(){}
    
    @Published public var defaultCornerRadius: CGFloat = 20

    @Published public var colors: DefaultColorDefinition = DefaultColorDefinition()

    public class DefaultColorDefinition: ColorDefinition {
        @Published public var background: Color = Color(.red)
        @Published public var secondaryBackground: Color = Color(.orange)
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
