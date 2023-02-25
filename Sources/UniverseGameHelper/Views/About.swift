//
//  About.swift
//  Moody
//
//  Created by Tom Arlt on 25.01.22.
//

import StoreKit
import SwiftUI

public struct About<base: BaseDefinition, colors: ColorDefinition, install: InstallationDefinitions, styling: StylingDefinition>: View {
    @State private var showInfo = false
    @State private var showAlert = false
    @State private var showBugreport = false
    @State private var showBugReportToast = false
    @State private var showOpeningSheet = false

    public var infoText: String?

    public var additionalListElementContainer: [AnyView]

    public var belowFootNote: [AnyView]

    public init<List, Below>(infoText: String? = nil,
                             @ViewBuilder additionalListElementContainer: @escaping () -> TupleView<List>,
                             @ViewBuilder belowFootNote: @escaping () -> TupleView<Below>) {
        self.infoText = infoText
        self.additionalListElementContainer = additionalListElementContainer().getViews
        self.belowFootNote = belowFootNote().getViews
    }

    public init<List: View, Below: View>(infoText: String? = nil,
                                         @ViewBuilder additionalListElementContainer: @escaping () -> List,
                                         @ViewBuilder belowFootNote: @escaping () -> Below) {
        self.infoText = infoText
        self.additionalListElementContainer = [AnyView(additionalListElementContainer())]
        self.belowFootNote = [AnyView(belowFootNote())]
    }

    public init(infoText: String? = nil) {
        self.infoText = infoText
        additionalListElementContainer = []
        belowFootNote = []
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

    var bugreport: some View {
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
            BugreportSheet(appname: base.appName, appVersionString: install.appVersionString, bugreportLink: base.bugreportLink, secondaryBackground: colors.secondaryBackground, primaryBackground: colors.background, showThank: $showBugReportToast)
        }
    }

    var github: some View {
        Link(destination: URL(string: base.githubLink)!) {
            ListElement(cornerRadius: styling.defaultCornerRadius, bgColor: colors.secondaryBackground) {
                Text(String(localized: "about.github", bundle: .module))
                Spacer()
            }
        }
        .buttonStyle(.borderless)
    }

    var developerWebsite: some View {
        Group {
            if !base.developerWebsite.isEmpty {
                Link(destination: URL(string: base.developerWebsite)!) {
                    ListElement(cornerRadius: styling.defaultCornerRadius, bgColor: colors.secondaryBackground) {
                        Text(String(localized: "about.website.developer", bundle: .module))
                        Spacer()
                    }
                }
                .buttonStyle(.borderless)
            }
        }
    }

    var appWebsite: some View {
        Group {
            if !base.appWebsite.isEmpty {
                Link(destination: URL(string: base.appWebsite)!) {
                    ListElement(cornerRadius: styling.defaultCornerRadius, bgColor: colors.secondaryBackground) {
                        Text(String(localized: "about.website.app", bundle: .module))
                        Spacer()
                    }
                }
                .buttonStyle(.borderless)
            }
        }
    }

    var support: some View {
        Group {
            if base.showSupportDonations {
                InAppSupportMe(defaultCornerRadius: styling.defaultCornerRadius, secondaryBackground: colors.secondaryBackground)
            }
        }
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                infoContainer

                github

                developerWebsite

                appWebsite

                bugreport

                support

                if base.showGitRepo {
                    ListElement(cornerRadius: styling.defaultCornerRadius, bgColor: colors.secondaryBackground) {
                        Text(String(localized: "about.gitrepo", bundle: .module))
                        Spacer()
                    }
                }

                ForEach(0 ..< additionalListElementContainer.count, id: \.self) { index in
                    additionalListElementContainer[index]
                }

                footnote

                ForEach(0 ..< belowFootNote.count, id: \.self) { index in
                    belowFootNote[index]
                }
            }
            .padding()
        }
        .background(colors.background)
    }
}

struct About_Previews: PreviewProvider {
    static var previews: some View {
        About<PreviewDefinitions.Base, PreviewDefinitions.Colors, PreviewDefinitions.Installation, PreviewDefinitions.Styling>
        {}
    belowFootNote: {
                ListElement(cornerRadius: 20, bgColor: Color.gray) {
                    AnyView(
                        HStack {
                            Text("hi")
                        }
                    )
                }
            }
    }
}
