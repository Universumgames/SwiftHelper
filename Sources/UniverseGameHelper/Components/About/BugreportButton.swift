//
//  BureportButton.swift
//  
//
//  Created by Tom Arlt on 17.03.24.
//

import SwiftUI

public struct BugreportButton: View {
    let background: Color
    let secondaryBackground: Color
    let defaultCornerRadius: CGFloat
    
    let bugreportLink: String
    
    let appName: String
    
    @State private var showBugreport = false
    @State private var showBugReportToast = false
    
    public var body: some View {
        Button {
            showBugreport.toggle()
        } label: {
            ListElement() {
                Text("about.bugreport".localisedInBundle(.module))
            }
        }
        .buttonStyle(.borderless)
        .sheet(isPresented: $showBugreport) {
            BugreportSheet(appname: appName, appVersionString: InstallationDefinitions.appVersionString, bugreportLink: bugreportLink, secondaryBackground: secondaryBackground, primaryBackground: background, showThank: $showBugReportToast)
        }
    }
}

#Preview {
    ScrollView {
        BugreportButton(background: .red, secondaryBackground: .blue, defaultCornerRadius: 10, bugreportLink: "https://www.google.com", appName: "Test App")
    }
}
