//
//  Footnote.swift
//  
//
//  Created by Tom Arlt on 17.03.24.
//

import SwiftUI

public struct Footnote: View {
    
    public var body: some View {
        VStack {
            InstallationDefinitions.createdByElement
            
            InstallationDefinitions.appVersionNote
            
            InstallationDefinitions.testFlightNote
        }
    }
}

#Preview {
    Footnote()
}
