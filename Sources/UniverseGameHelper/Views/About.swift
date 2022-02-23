//
//  About.swift
//  Moody
//
//  Created by Tom Arlt on 25.01.22.
//

import SwiftUI

struct About<base: BaseDefinition, colors: ColorDefinition, install: InstallationDefinitions, styling: StylingDefinition>: View {
    @State private var showInfo = false
    @State private var showAlert = false
    @State private var showBugreport = false
    @State private var showBugReportToast = false
    @State private var showOpeningSheet = false

    var infoText: String?

    var additionalListElements: [ListElement<AnyView>] = []

    var belowFootNote: ListElement<AnyView>? = nil

    var infoContainer: some View {
        Group {
            if let infoText = infoText {
                ListElement(cornerRadius: styling.defaultCornerRadius, bgColor: colors.secondaryBackground) {
                    VStack {
                        HStack {
                            Text("about.button.information")
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

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                }

                infoContainer

                Link(destination: URL(string: base.githubLink)!) {
                    ListElement(cornerRadius: styling.defaultCornerRadius, bgColor: colors.secondaryBackground) {
                        Text("about.github")
                        Spacer()
                    }
                }
                .buttonStyle(.borderless)

                Button {
                    showBugreport.toggle()
                } label: {
                    ListElement(cornerRadius: styling.defaultCornerRadius, bgColor: colors.secondaryBackground) {
                        Text("about.bugreport")
                        Spacer()
                    }
                }
                .buttonStyle(.borderless)
                .sheet(isPresented: $showBugreport) {
                    BugreportSheet(appname: base.appName, appVersionString: install.appVersionString, bugreportLink: base.bugreportLink, secondaryBackground: colors.secondaryBackground, showThank: $showBugReportToast)
                }

                Link(destination: URL(string: base.bmcLink)!) {
                    ListElement(cornerRadius: styling.defaultCornerRadius, bgColor: colors.secondaryBackground) {
                        Text("button.support")
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
                        Link("about.gitrepo", destination: URL(string: base.gitRepoLink)!)
                        Spacer()
                    }
                }

                Link(destination: URL(string: base.bmcLink)!) {
                    Image("bmc")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(styling.defaultCornerRadius)
                }
                .buttonStyle(.borderless)

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
