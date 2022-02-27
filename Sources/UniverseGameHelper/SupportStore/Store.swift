//
//  Store.swift
//  VideoConferenceManager
//
//  Created by Tom Arlt on 25.02.22.
//

import Foundation
import StoreKit

public enum StoreError: Error {
    case failedVerification
}

public class Store: ObservableObject {
    @Published private(set) var supportLevels: [Product]
    @Published private(set) var purchasedIdentifiers = Set<String>()

    public var updateListenerTask: Task<Void, Error>?

    public init() {
        supportLevels = []
        updateListenerTask = listenForTransactions()
        Task {
            await requestProducts()
        }
    }

    public func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            // Iterate through any transactions which didn't come from a direct call to `purchase()`.
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)

                    // Deliver content to the user.
                    await self.updatePurchasedIdentifiers(transaction)

                    // Always finish a transaction.
                    await transaction.finish()
                } catch {
                    // StoreKit has a receipt it can read but it failed verification. Don't deliver content to the user.
                    print("Transaction failed verification")
                }
            }
        }
    }

    @MainActor
    public func requestProducts() async {
        do {
            // Request products from the App Store using the identifiers defined in the Products.plist file.
            let storeProducts = try await Product.products(for: SupportStoreKitKey.allCases.map { $0.rawValue })

            var supports: [Product] = []

            // Filter the products into different categories based on their type.
            for product in storeProducts {
                switch product.type {
                case .consumable:
                    supports.append(product)
                default:
                    // Ignore this product.
                    print("Unknown product")
                }
            }

            // Sort each product category by price, lowest to highest, to update the store.
            supportLevels = supports
        } catch {
            print("Failed product request: \(error)")
        }
    }

    public func purchase(_ product: Product) async throws -> Transaction? {
        // Begin a purchase.
        let result = try await product.purchase()

        switch result {
        case let .success(verification):
            let transaction = try checkVerified(verification)

            // Deliver content to the user.
            await updatePurchasedIdentifiers(transaction)

            // Always finish a transaction.
            await transaction.finish()

            return transaction
        case .userCancelled, .pending:
            return nil
        default:
            return nil
        }
    }

    public func isPurchased(_ productIdentifier: String) async throws -> Bool {
        // Get the most recent transaction receipt for this `productIdentifier`.
        guard let result = await Transaction.latest(for: productIdentifier) else {
            // If there is no latest transaction, the product has not been purchased.
            return false
        }

        let transaction = try checkVerified(result)

        // Ignore revoked transactions, they're no longer purchased.

        // For subscriptions, a user can upgrade in the middle of their subscription period. The lower service
        // tier will then have the `isUpgraded` flag set and there will be a new transaction for the higher service
        // tier. Ignore the lower service tier transactions which have been upgraded.
        return transaction.revocationDate == nil && !transaction.isUpgraded
    }

    public func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        // Check if the transaction passes StoreKit verification.
        switch result {
        case .unverified:
            // StoreKit has parsed the JWS but failed verification. Don't deliver content to the user.
            throw StoreError.failedVerification
        case let .verified(safe):
            // If the transaction is verified, unwrap and return it.
            return safe
        }
    }

    @MainActor
    public func updatePurchasedIdentifiers(_ transaction: Transaction) async {
        if transaction.revocationDate == nil {
            // If the App Store has not revoked the transaction, add it to the list of `purchasedIdentifiers`.
            purchasedIdentifiers.insert(transaction.productID)
        } else {
            // If the App Store has revoked this transaction, remove it from the list of `purchasedIdentifiers`.
            purchasedIdentifiers.remove(transaction.productID)
        }
    }
}
