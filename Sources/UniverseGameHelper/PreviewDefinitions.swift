//
//  File.swift
//
//
//  Created by Tom Arlt on 23.02.22.
//

import Foundation
import SwiftUI
import StoreKit

class PreviewDefinitions {
    class Base: BaseDefinition {
        
        static var bmcLink: String { "" }

        static var githubLink: String { "" }

        static var bugreportLink: String { "" }

        static var showGitRepo: Bool { true }

        static var gitRepoLink: String { "" }

        static var appName: String { "" }
        
        static func supportShop() -> [Product] {
            []
        }
    }

    class Colors: ColorDefinition {
        static var background: Color { Color.black }

        static var secondaryBackground: Color { Color.gray }
    }

    class Installation: InstallationDefinitions {
    }

    class Styling: StylingDefinition {
        static var defaultCornerRadius: CGFloat { 20 }
    }
}
