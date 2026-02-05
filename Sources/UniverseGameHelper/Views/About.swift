//
//  About.swift
//  Moody
//
//  Created by Tom Arlt on 25.01.22.
//

import MarkdownUI
import StoreKit
import SwiftUI

public struct About<base: BaseDefinition>: View {
    @Environment(\.styling) var styling
    @State private var showAlert = false
    @State private var showOpeningSheet = false

    public var infoText: String?

    public var additionalListElementContainer: [AnyView]

    public var belowFootNote: [AnyView]

    public init<ListElements, BelowElements>(infoText: String? = nil,
                                             @ViewBuilder additionalListElements: @escaping () -> TupleView<ListElements>,
                                             @ViewBuilder belowFootNotes: @escaping () -> TupleView<BelowElements>) {
        self.infoText = infoText
        additionalListElementContainer = additionalListElements().getViews
        belowFootNote = belowFootNotes().getViews
    }

    public init<ListElements: View, BelowElements: View>(infoText: String? = nil,
                                                         @ViewBuilder additionalListElementContainer: @escaping () -> ListElements,
                                                         @ViewBuilder belowFootNote: @escaping () -> BelowElements) {
        self.infoText = infoText
        self.additionalListElementContainer = [AnyView(additionalListElementContainer())]
        self.belowFootNote = [AnyView(belowFootNote())]
    }

    public init<ListElements>(infoText: String? = nil,
                              @ViewBuilder additionalListElements: @escaping () -> TupleView<ListElements>) {
        self.infoText = infoText
        additionalListElementContainer = additionalListElements().getViews
        belowFootNote = []
    }

    public init<ListElements: View>(infoText: String? = nil,
                                    @ViewBuilder additionalListElementContainer: @escaping () -> ListElements) {
        self.infoText = infoText
        self.additionalListElementContainer = [AnyView(additionalListElementContainer())]
        belowFootNote = []
    }

    public init<BelowElements>(infoText: String? = nil,
                               @ViewBuilder belowFootNotes: @escaping () -> TupleView<BelowElements>) {
        self.infoText = infoText
        additionalListElementContainer = []
        belowFootNote = belowFootNotes().getViews
    }

    public init<BelowElements: View>(infoText: String? = nil,
                                     @ViewBuilder belowFootNote: @escaping () -> BelowElements) {
        self.infoText = infoText
        additionalListElementContainer = []
        self.belowFootNote = [AnyView(belowFootNote())]
    }

    public init(infoText: String? = nil) {
        self.infoText = infoText
        additionalListElementContainer = []
        belowFootNote = []
    }

    var developerWebsite: some View {
        Group {
            Link(destination: URL(string: DeveloperInfo.developerWebsite)!) {
                ListElement {
                    Text(String(localized: "about.website.developer", bundle: .module))
                }
            }
            .buttonStyle(.borderless)
        }
    }

    var appWebsite: some View {
        Group {
            if !base.appWebsite.isEmpty {
                Link(destination: URL(string: base.appWebsite)!) {
                    ListElement {
                        Text(String(localized: "about.website.app", bundle: .module))
                    }
                }
                .buttonStyle(.borderless)
            }
        }
    }

    var support: some View {
        Group {
            if base.showSupportDonations {
                InAppSupportMe(secondaryBackground: styling.colors.secondaryBackground)
            }
        }
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let infoText = infoText {
                    InfoContainer(infoText: infoText, defaultCornerRadius: styling.defaultCornerRadius, secondaryBackground: styling.colors.secondaryBackground)
                }

                GitHubLinkButton(secondaryBackground: styling.colors.secondaryBackground, cornerRadius: styling.defaultCornerRadius, githubLink: DeveloperInfo.githubLink)

                developerWebsite

                appWebsite

                // check if not watchos
                #if !os(watchOS)
                BugreportButton(background: styling.colors.background, secondaryBackground: styling.colors.secondaryBackground, defaultCornerRadius: styling.defaultCornerRadius, bugreportLink: DeveloperInfo.bugreportLink, appName: InstallationDefinitions.appName)
                #endif
                
                support

                if base.showGitRepo {
                    ListElement {
                        Text(String(localized: "about.gitrepo", bundle: .module))
                    }
                }

                ForEach(0 ..< additionalListElementContainer.count, id: \.self) { index in
                    additionalListElementContainer[index]
                }

                Footnote()

                ForEach(0 ..< belowFootNote.count, id: \.self) { index in
                    belowFootNote[index]
                }
            }
            .padding()
        }
        .background(styling.colors.background)
    }
}

/* struct About_Previews: PreviewProvider {
     static var previews: some View {
         About<PreviewDefinitions.Base, PreviewDefinitions.Colors, PreviewDefinitions.Styling>
         {}
     belowFootNote: {
                 ListElement(cornerRadius: 20, bgColor: Color.gray) {
                     Text("hi")
                 }
             }
     }
 }
 */
