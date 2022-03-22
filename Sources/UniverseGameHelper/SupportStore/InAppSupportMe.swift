//
//  InAppSupportMe.swift
//  VideoConferenceManager
//
//  Created by Tom Arlt on 26.02.22.
//

import StoreKit
import SwiftUI

public struct InAppSupportMe: View {
    @EnvironmentObject var store: Store
    @State var showThankAlert = false
    
    public var defaultCornerRadius: CGFloat
    public var secondaryBackground: Color

    public var body: some View {
        ListElement(cornerRadius: defaultCornerRadius, bgColor: secondaryBackground) {
            VStack {
                Text(String(localized: "support.title", bundle: .module))
                    .padding()
                Text(String(localized: "support.note", bundle: .module))
                    .font(.caption2)
                    .padding([.bottom])

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
    public func buyButton(support: Product) -> some View {
        Button {
            Task {
                do {
                    let _ = try await store.purchase(support)
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
        InAppSupportMe(defaultCornerRadius: PreviewDefinitions.Styling.defaultCornerRadius, secondaryBackground: PreviewDefinitions.Colors.secondaryBackground)
            .previewLayout(.sizeThatFits)
            .environmentObject( Store(productKeys: ExampleSupportStoreKitKeys.allCases.map { $0.rawValue }))
    }
}
