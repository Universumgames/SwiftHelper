//
//  InAppSupportMe.swift
//  VideoConferenceManager
//
//  Created by Tom Arlt on 26.02.22.
//

import StoreKit
import SwiftUI
import UniverseGameHelper

struct InAppSupportMe: View {
    @EnvironmentObject var store: Store
    @State var showThankAlert = false

    var body: some View {
        ListElement(cornerRadius: Definitions.defaultCornerRadius, bgColor: Definitions.Colors.secondaryBackground) {
            VStack {
                Text("support.title")
                    .padding()
                Text("support.note")
                    .font(.caption2)

                ForEach(store.supportLevels) { product in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(product.displayName)
                            Text(product.description)
                                .font(.caption2)
                        }
                        Spacer()
                        buyButton(support: product)
                    }
                    .padding(.bottom)
                }

                if store.supportLevels.isEmpty {
                    Text(String(localized: "support.empty", bundle: .module))
                }
            }
            Spacer()
        }
        .alert(isPresented: $showThankAlert) {
            Alert(title: Text(String(localized: "support.thank.title", bundle: .module)), message: Text(String(localized: "support.thank", bundle: .module)))
        }
    }

    @ViewBuilder
    func buyButton(support: Product) -> some View {
        Button {
            Task {
                do {
                    try await store.purchase(support)
                } catch {
                }
            }
        } label: {
            Text(support.displayPrice)
        }
        .onChange(of: store.purchasedIdentifiers) { identifiers in
            Task {
                showThankAlert = showThankAlert || identifiers.contains(support.id)
            }
        }
    }
}

struct InAppSupportMe_Previews: PreviewProvider {
    static var previews: some View {
        InAppSupportMe()
            .environmentObject(Store())
    }
}
