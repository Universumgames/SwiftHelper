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

    public var assetPathPrefix: String

    public init(isFirstInstall: Bool, firstInstallMarkdown: String, whatsNewMarkdown: String, assetPathPrefix: String = "asset") {
        self.isFirstInstall = isFirstInstall
        freshInstallContent = firstInstallMarkdown
        whatsNewContent = whatsNewMarkdown
        self.assetPathPrefix = assetPathPrefix
    }

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
                if isFirstInstall {
                    VStack {
                        ScrollView {
                            VStack(alignment: .leading) {
                                Markdown(freshInstallContent)
                                    .markdownImageProvider(.asset)
                                HStack {
                                    Spacer()
                                }
                            }
                            .padding()
                        }
                    }
                }
                VStack {
                    ScrollView {
                        VStack(alignment: .leading) {
                            Markdown(whatsNewContent)
                                .markdownImageProvider(.asset)
                        }
                        .padding()
                    }
                }
            }
            .padding()
            #if os(iOS)
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
            #endif
        }
    }
}

struct StartupSheet_Previews: PreviewProvider {
    static var previews: some View {
        StartupSheet(isFirstInstall: true, firstInstallMarkdown: "", whatsNewMarkdown: "")
    }
}
