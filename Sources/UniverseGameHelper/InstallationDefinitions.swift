//
//  InstallationDefinitions.swift
//  
//
//  Created by Tom Arlt on 23.02.22.
//

import Foundation
import SwiftUI

public extension InstallationDefinitions{
    static var isTestflightInstallation: Bool {
        return Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"
    }

    static var isFirstInstall: Bool {
        let val = UserDefaults.standard.string(forKey: "version") == nil
        return val
    }

    static func updateLastVersion() {
        UserDefaults.standard.set(appVersionString, forKey: "version")
    }

    static var isNewVersion: Bool {
        let v = UserDefaults.standard.string(forKey: "version")
        return v == nil || v != appVersionString
    }

    static var showStartupSheet: Bool {
        return isFirstInstall || isNewVersion
    }

    static var testFlightNote: some View {
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

    static var releaseVersionNumber: String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }

    static var buildVersionNumber: String? {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    }

    static var appVersionString: String {
        return "Version \(releaseVersionNumber ?? "unkown")\(buildVersionNumber != nil ? " build" + buildVersionNumber! : "")"
    }

    static var appVersionNote: some View {
        HStack {
            Spacer()
            Text(appVersionString)
                .font(.footnote)
            Spacer()
        }
    }
}
