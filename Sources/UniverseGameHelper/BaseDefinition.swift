//
//  BaseDefinition.swift
//
//
//  Created by Tom Arlt on 23.02.22.
//

import Foundation
import StoreKit
import SwiftUI

public protocol StylingDefinition {
    static var defaultCornerRadius: CGFloat { get }
}

public protocol InstallationDefinitions {
    associatedtype testFlightNoteType: View
    associatedtype appVersionNoteType: View

    static var isTestflightInstallation: Bool { get }

    static var isFirstInstall: Bool { get }
    static func updateLastVersion()

    static var isNewVersion: Bool { get }

    static var showStartupSheet: Bool { get }

    @ViewBuilder
    static var testFlightNote: testFlightNoteType { get }

    static var releaseVersionNumber: String? { get }

    static var buildVersionNumber: String? { get }

    static var appVersionString: String { get }

    static var appVersionNote: appVersionNoteType { get }
}

public protocol ColorDefinition {
    static var background: Color { get }
    static var secondaryBackground: Color { get }
}

public protocol BaseDefinition {
    associatedtype createdByType: View

    static var githubLink: String { get }
    static var developerWebsite: String { get }
    static var appWebsite: String { get }

    static var showSupportDonations: Bool { get }

    static var bugreportLink: String { get }

    static var showGitRepo: Bool { get }
    static var gitRepoLink: String { get }

    static var appName: String { get }

    static var createdByElement: createdByType { get }
}
