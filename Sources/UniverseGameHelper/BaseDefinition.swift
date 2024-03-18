//
//  BaseDefinition.swift
//
//
//  Created by Tom Arlt on 23.02.22.
//

import Foundation
import StoreKit
import SwiftUI

public protocol BaseDefinition {
    static var appWebsite: String { get }

    static var showSupportDonations: Bool { get }

    static var showGitRepo: Bool { get }
    static var gitRepoLink: String { get }
}
