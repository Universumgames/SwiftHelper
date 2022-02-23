//
//  Bugreport.swift
//  Moody
//
//  Created by Tom Arlt on 08.02.22.
//

import SwiftUI

struct BugreportSheet: View {
    @Environment(\.dismiss) var dismiss
    
    var appname: String
    var appVersionString: String
    var bugreportLink: String
    
    
    var secondaryBackground: Color

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var mail: String = ""

    @Binding var showThank: Bool

    func checkAllRequired() -> Bool {
        return !title.isEmpty && !description.isEmpty
    }

    var header: some View {
        HStack {
            Button{
                dismiss()
            } label: {
                Text(String(localized: "button.cancel", bundle: .module))
            }
            Spacer()
            Text(String(localized: "bugreport.sheetTitle", bundle: .module))
                .font(.title)
                .padding()
            Spacer()
            Button {
                if checkAllRequired() {
                    let result = Bugreport.reportBug(for: appname, version: appVersionString, title: title, description: description, from: mail, to: bugreportLink)
                    showThank = result
                    dismiss()
                }
            } label: {
                Text(String(localized: "button.sendbugreport", bundle: .module))
            }
        }
    }

    var body: some View {
        VStack {
            header
                .padding()

            VStack(alignment: .leading) {
                Text(String(localized: "bugreport.note", bundle: .module))
                    .font(.footnote)
                    .padding()
                Text(String(localized: "bugreport.title", bundle: .module))
                TextField(String(localized: "bugreport.title", bundle: .module), text: $title)
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
            }
        }
        .padding()
    }
}

struct Bugreport_Previews: PreviewProvider {
    static var previews: some View {
        BugreportSheet(appname: "Testapp", appVersionString: "perview-version", bugreportLink: "https://google.com", secondaryBackground: Color.blue, showThank: .constant(false))
    }
}
