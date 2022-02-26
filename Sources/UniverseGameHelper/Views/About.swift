//
//  About.swift
//  Moody
//
//  Created by Tom Arlt on 25.01.22.
//

import SwiftUI
import StoreKit

public struct About<base: BaseDefinition, colors: ColorDefinition, install: InstallationDefinitions, styling: StylingDefinition>: View {
    @State private var showInfo = false
    @State private var showAlert = false
    @State private var showBugreport = false
    @State private var showBugReportToast = false
    @State private var showOpeningSheet = false

    public var infoText: String?

    public var additionalListElements: [ListElement<AnyView>] = []

    public var belowFootNote: ListElement<AnyView>?

    public init(supportCallback: @escaping (String) -> Void, infoText: String? = nil, additionalListElements: [ListElement<AnyView>] = [], belowFootNote: ListElement<AnyView>? = nil) {
        self.infoText = infoText
        self.additionalListElements = additionalListElements
        self.belowFootNote = belowFootNote
    }

    var infoContainer: some View {
        Group {
            if let infoText = infoText {
                ListElement(cornerRadius: styling.defaultCornerRadius, bgColor: colors.secondaryBackground) {
                    VStack {
                        HStack {
                            Text(String(localized: "about.button.information", bundle: .module))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .rotationEffect(.degrees(showInfo ? 90 : 0))
                                .animation(.easeInOut, value: showInfo)
                        }
                        .background(colors.secondaryBackground)
                        .cornerRadius(styling.defaultCornerRadius)

                        if showInfo {
                            VStack {
                                Text(infoText)
                            }
                            .padding()
                            .transition(.scale.animation(.easeInOut(duration: 0.25)))
                        }
                    }
                }
                .onTapGesture {
                    withAnimation {
                        showInfo.toggle()
                    }
                }
            }
        }
    }

    var footnote: some View {
        Group {
            base.createdByElement

            install.appVersionNote

            install.testFlightNote
        }
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                infoContainer

                Link(destination: URL(string: base.githubLink)!) {
                    ListElement(cornerRadius: styling.defaultCornerRadius, bgColor: colors.secondaryBackground) {
                        Text(String(localized: "about.github", bundle: .module))
                        Spacer()
                    }
                }
                .buttonStyle(.borderless)

                Button {
                    showBugreport.toggle()
                } label: {
                    ListElement(cornerRadius: styling.defaultCornerRadius, bgColor: colors.secondaryBackground) {
                        Text(String(localized: "about.bugreport", bundle: .module))
                        Spacer()
                    }
                }
                .buttonStyle(.borderless)
                .sheet(isPresented: $showBugreport) {
                    BugreportSheet(appname: base.appName, appVersionString: install.appVersionString, bugreportLink: base.bugreportLink, secondaryBackground: colors.secondaryBackground, showThank: $showBugReportToast)
                }

                Link(destination: URL(string: base.bmcLink)!) {
                    ListElement(cornerRadius: styling.defaultCornerRadius, bgColor: colors.secondaryBackground) {
                        Text(String(localized: "about.support", bundle: .module))
                        Spacer()
                        Image("bmc_cup")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                    }
                }
                .buttonStyle(.borderless)

                if base.showGitRepo {
                    ListElement(cornerRadius: styling.defaultCornerRadius, bgColor: colors.secondaryBackground) {
                        Text(String(localized: "about.gitrepo", bundle: .module))
                        Spacer()
                    }
                }

                ForEach(0 ..< additionalListElements.count) { index in
                    additionalListElements[index]
                }

                footnote

                if let belowFootNote = belowFootNote {
                    belowFootNote
                }
            }
            .padding()
        }
    }
}

struct About_Previews: PreviewProvider {
    static var previews: some View {
        About<PreviewDefinitions.Base, PreviewDefinitions.Colors, PreviewDefinitions.Installation, PreviewDefinitions.Styling>(belowFootNote:
            ListElement(cornerRadius: 20, bgColor: Color.gray) {
                AnyView(
                    HStack {
                        Text("hi")
                    }
                )
            }
        )
    }
}
