//
//  BaseDefinitionExtension.swift
//
//
//  Created by Tom Arlt on 23.02.22.
//

import Foundation
import SwiftUI

public extension BaseDefinition {
    static var createdByElement: some View {
        HStack {
            Spacer()
            Text("Developed by UniversumGames")
                .font(.footnote)
            Spacer()
        }
    }
}
