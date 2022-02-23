//
//  StartupSheet.swift
//  Moody
//
//  Created by Tom Arlt on 15.02.22.
//

import MarkdownUI
import SwiftUI

public struct StartupSheet: View {
    @Environment(\.dismiss) var dismiss

    public var isFirstInstall: Bool
    public var freshInstallContent: String
    public var whatsNewContent: String

    public var assetPathPrefix: String = "assset"

    public var overrideFreshInstall = false

    var head: some View {
        HStack {
            Spacer()
            Button {
                dismiss()
            } label: {
                Text(String(localized: "button.skip", bundle: .module))
                    .font(.title2)
            }
        }
        .padding()
    }

    public var body: some View {
        VStack {
            head
            TabView {
                Group {
                    if isFirstInstall || overrideFreshInstall {
                        ScrollView {
                            VStack(alignment: .leading) {
                                Markdown(freshInstallContent)
                                    .setImageHandler(.assetImage(), forURLScheme: assetPathPrefix)
                                HStack {
                                    Spacer()
                                }
                            }
                            .padding()
                        }
                    }
                    ScrollView {
                        VStack(alignment: .leading) {
                            Markdown(whatsNewContent)
                                .setImageHandler(.assetImage(), forURLScheme: assetPathPrefix)
                        }
                        .padding()
                    }
                }
                .padding()
            }
            #if os(iOS)
                .tabViewStyle(PageTabViewStyle())
            #endif
        }
    }
}

struct StartupSheet_Previews: PreviewProvider {
    static var previews: some View {
        StartupSheet(isFirstInstall: true, freshInstallContent: "", whatsNewContent: "")
    }
}
