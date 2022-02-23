//
//  BaseDefinition.swift
//
//
//  Created by Tom Arlt on 23.02.22.
//

import Foundation
import SwiftUI

public protocol StylingDefinition {
    static var defaultCornerRadius: CGFloat { get }
}

public protocol InstallationDefinitions {
    associatedtype Content: View

    static var isTestflightInstallation: Bool { get }

    static var isFirstInstall: Bool { get }
    static func updateLastVersion()

    static var isNewVersion: Bool { get }

    static var showStartupSheet: Bool { get }

    static var testFlightNote: Content { get }

    static var releaseVersionNumber: String? { get }

    static var buildVersionNumber: String? { get }

    static var appVersionString: String { get }

    static var appVersionNote: Content { get }
}

public protocol MainColors {
    static var background: Color { get }
    static var secondaryBackground: Color { get }
}

public protocol BaseDefinition {
    static var bmcLink: String { get }
    static var githubLink: String { get }

    static var bugreportLink: String { get }

    static var showGitRepo: Bool { get }
    static var gitRepoLink: String { get }

    associatedtype Content: View
    static var createdByElement: Content { get }
}
