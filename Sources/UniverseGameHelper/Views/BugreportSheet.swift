//
//  Bugreport.swift
//  Moody
//
//  Created by Tom Arlt on 08.02.22.
//

import SwiftUI

public struct BugreportSheet: View {
    @Environment(\.dismiss) var dismiss

    public var appname: String
    public var appVersionString: String
    public var bugreportLink: String
    public var secondaryBackground: Color
    public var primaryBackground: Color?

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var mail: String = ""

    @Binding var showThank: Bool

    public init(appname: String, appVersionString: String, bugreportLink: String, secondaryBackground: Color, primaryBackground: Color? = nil, showThank: Binding<Bool> = .constant(false)) {
        self.appname = appname
        self.appVersionString = appVersionString
        self.bugreportLink = bugreportLink
        self.secondaryBackground = secondaryBackground
        self.primaryBackground = primaryBackground
        _showThank = showThank
    }

    func checkAllRequired() -> Bool {
        return !title.isEmpty && !description.isEmpty
    }

    var header: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Text(String(localized: "button.cancel", bundle: .module))
                    .font(.subheadline)
                    .allowsTightening(true)
            }
            Spacer()
            Text(String(localized: "bugreport.sheetTitle", bundle: .module))
                .font(.title2)
                .allowsTightening(true)
            Spacer()
            Button {
                if checkAllRequired() {
                    let result = Bugreport.reportBug(for: appname, version: appVersionString, title: title, description: description, from: mail, to: bugreportLink)
                    showThank = result
                    dismiss()
                }
            } label: {
                Text(String(localized: "button.sendbugreport", bundle: .module))
                    .font(.subheadline)
                    .allowsTightening(true)
            }
        }
    }

    public var body: some View {
        VStack {
            header
                .padding([.bottom], 5.0)

            ScrollView {
                VStack(alignment: .leading) {
                    Text(String(localized: "bugreport.note", bundle: .module))
                        .font(.footnote)
                        .lineLimit(Int.max)
                        .padding([.top, .bottom])
                    Text(String(localized: "bugreport.title", bundle: .module))
                    TextField(String(localized: "bugreport.title", bundle: .module), text: $title)
                        .allowsTightening(true)
                        .padding()
                        .background(secondaryBackground)
                        .cornerRadius(10)
                    Text(String(localized: "bugreport.mail", bundle: .module))
                    TextField(String(localized: "bugreport.mail", bundle: .module), text: $mail)
                    #if os(iOS)
                        .keyboardType(.emailAddress)
                    #endif
                        .padding()
                        .background(secondaryBackground)
                        .cornerRadius(10)
                    Text(String(localized: "bugreport.description", bundle: .module))
                        .allowsTightening(true)
                    if #available(iOS 16.0, *) {
                        TextEditor(text: $description)
#if os(iOS)
                            .textInputAutocapitalization(.sentences)
                            .keyboardType(.default)
                            .multilineTextAlignment(.leading)
#endif
                            .allowsTightening(true)
                            .padding()
                            .background(secondaryBackground)
                            .cornerRadius(10)
                            .frame(height: 500)
                            .scrollContentBackground(.hidden)
                    } else {
                        TextEditor(text: $description)
#if os(iOS)
                            .textInputAutocapitalization(.sentences)
                            .keyboardType(.default)
                            .multilineTextAlignment(.leading)
#endif
                            .allowsTightening(true)
                            .padding()
                            .background(secondaryBackground)
                            .cornerRadius(10)
                            .frame(height: 500)
                    }
                }
            }
        }
        .padding()
        .background(primaryBackground)
    }
}

struct Bugreport_Previews: PreviewProvider {
    static var previews: some View {
        BugreportSheet(appname: "test app", appVersionString: "test version", bugreportLink: "https://google.com", secondaryBackground: Color.gray, showThank: .constant(false))
    }
}
