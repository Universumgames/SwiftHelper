//
//  InstallationDefinitions.swift
//
//
//  Created by Tom Arlt on 23.02.22.
//

import Foundation
import SwiftUI

open class InstallationDefinitions {
    public static var isTestflightInstallation: Bool {
        var isSim = false
        #if targetEnvironment(simulator)
            isSim = true
        #endif
        return Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt" || isSim
    }

    public static var isFirstInstall: Bool {
        let val = UserDefaults.standard.string(forKey: "version") == nil
        return val
    }

    public static func updateLastVersion() {
        UserDefaults.standard.set(appVersionString, forKey: "version")
    }

    public static var isNewVersion: Bool {
        let v = UserDefaults.standard.string(forKey: "version")
        return v != nil && v != appVersionString
    }

    public static var showStartupSheet: Bool {
        isFirstInstall || isNewVersion
    }

    public static var testFlightNote: some View {
        Group {
            if isTestflightInstallation {
                HStack {
                    Spacer()
                    Text("This application is downloaded via Testflight, \nyou're running a beta of the application")
                        .font(.footnote)
                        .foregroundColor(Color.orange)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
            }
        }
    }

    public static var releaseVersionNumber: String? {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }

    public static var buildVersionNumber: String? {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    }

    public static var appVersionString: String {
        "Version \(releaseVersionNumber ?? "unkown")\(buildVersionNumber != nil ? " build" + buildVersionNumber! : "")"
    }

    public static var appVersionNote: some View {
        HStack {
            Spacer()
            Text(appVersionString)
                .font(.footnote)
            Spacer()
        }
    }

    public static var appName: String {
        Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "unkown"
    }

    public static var createdByElement: some View {
        HStack {
            Spacer()
            Text("Developed by UniversumGames")
                .font(.footnote)
            Spacer()
        }
    }
}
