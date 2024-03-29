import Foundation
import StoreKit
import SwiftyStoreKit
import SwiftyUserDefaults
import UIKit

public typealias PayerCompletion<T, U> = ((T, U) -> Void)
public typealias PayerProducts = (Set<SKProduct>) -> Void

extension DefaultsKeys {
    var isPurchased: DefaultsKey<Bool> { .init("isPurchased", defaultValue: false) }
    var isAllowedToFetch: DefaultsKey<Bool> { .init("isAllowedToFetch", defaultValue: false) }
}

public protocol Payerable: AnyObject {
    func purchase(product id: String, completion: @escaping PayerCompletion<Bool, String?>)
    func restore(completion: @escaping PayerCompletion<Bool, String?>)
    func verifySubscriptions(completion: @escaping PayerCompletion<Bool, String?>)
    func getInfoSubscriptions(completion: @escaping PayerProducts)
    func completeTransactions(completion: @escaping PayerCompletion<Any, Any>)
}

open class Payer: NSObject {
    private var listSubscription: [String] = []
    private var appleSharedSecretKey: String = ""
    private var services: AppleReceiptValidator.VerifyReceiptURLType = .production
    
    public static let shared = Payer()
    
    public func config(listSubscription: [String],
                       services: AppleReceiptValidator.VerifyReceiptURLType = .production,
                       appleSharedSecretKey: String)
    {
        self.listSubscription = listSubscription
        self.services = services
        self.appleSharedSecretKey = appleSharedSecretKey
    }
    
    private func checkAllowedToFetch() -> Bool {
        return Defaults[\.isAllowedToFetch]
    }
    
    private func setAllowedToFetch() {
        Defaults[\.isAllowedToFetch] = true
    }
    
    public var isPurchased: Bool {
        return Defaults[\.isPurchased]
    }
}

extension Payer {
    public func purchase(product id: String, completion: @escaping PayerCompletion<Bool, String?>) {
        SwiftyStoreKit.purchaseProduct(id,
                                       quantity: 1,
                                       atomically: true) { result in
            switch result {
            case .success:
                print("Purchase success")
                Defaults[\.isPurchased] = true
                self.setAllowedToFetch()
                completion(true, nil)
            case .error(let error):
                switch error.code {
                case .unknown:
                    completion(false, "Purchase fail, please try again!")
                case .clientInvalid:
                    completion(false, "Not allowed to make the payment")
                case .paymentCancelled:
                    completion(false, "Payment cancelled")
                case .paymentInvalid:
                    completion(false, "The purchase identifier was invalid")
                case .paymentNotAllowed:
                    completion(false, "The device is not allowed to make the payment")
                case .storeProductNotAvailable:
                    completion(false, "The product is not available in the current storefront")
                case .cloudServicePermissionDenied:
                    completion(false, "Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed:
                    completion(false, "Could not connect to the network")
                case .cloudServiceRevoked:
                    completion(false, "User has revoked permission to use this cloud service")
                default:
                    completion(false, (error as NSError).localizedDescription)
                }
            }
        }
    }
    
    public func restore(completion: @escaping PayerCompletion<Bool, String?>) {
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if results.restoreFailedPurchases.count > 0 {
                completion(false, "Restore Failed: \(results.restoreFailedPurchases)")
            }
            else if results.restoredPurchases.count > 0 {
                print("Restore Success: \(results.restoredPurchases)")
                self.verifySubscriptions { isSuccess, errorMsg in
                    if isSuccess {
                        Defaults[\.isPurchased] = true
                        self.setAllowedToFetch()
                        completion(true, nil)
                    }
                    else {
                        completion(false, errorMsg)
                    }
                }
            }
            else {
                completion(false, "Nothing to restore")
            }
        }
    }
    
    public func verifySubscriptions(completion: @escaping PayerCompletion<Bool, String?>) {
        if listSubscription.isEmpty {
            fatalError("List subscription must not empty. Please add use method `configs` to set list subscription")
        }
        let appleValidator = AppleReceiptValidator(service: self.services,
                                                   sharedSecret: self.appleSharedSecretKey)
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            switch result {
            case .success(let receipt):
                let productIds = Set(self.listSubscription)
                let purchaseResult = SwiftyStoreKit.verifySubscriptions(productIds: productIds, inReceipt: receipt)
                switch purchaseResult {
                case .purchased:
                    completion(true, nil)
                case .expired(let expiryDate, _):
                    let msg = "Products are expired since \(expiryDate), please purchase again!"
                    completion(false, msg)
                case .notPurchased:
                    let msg = "The user has never purchased \(productIds)!"
                    completion(false, msg)
                }
            case .error(let error):
                let msg = "Receipt verification failed: \(error)"
                completion(false, msg)
            }
        }
    }
    
    public func getInfoSubscriptions(completion: @escaping (Set<SKProduct>) -> Void) {
        SwiftyStoreKit.retrieveProductsInfo(Set(listSubscription)) { result in
            if let invalidProductId = result.invalidProductIDs.first {
                print("Invalid product identifier: \(invalidProductId)")
            }
            if let error = result.error {
                print("error = \(error.localizedDescription)")
            }
            completion(result.retrievedProducts)
        }
    }
    
    public func completeTransactions(completion: @escaping PayerCompletion<Any, Any>) {
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                case .failed, .purchasing, .deferred:
                    break
                @unknown default:
                    break
                }
            }
        }
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        if self.checkAllowedToFetch() {
            self.verifySubscriptions { isSuccess, _ in
                if isSuccess {
                    Defaults[\.isPurchased] = true
                    self.setAllowedToFetch()
                    dispatchGroup.leave()
                }
                else {
                    Defaults[\.isPurchased] = false
                    dispatchGroup.leave()
                }
            }
        }
        else {
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) {
            print("Transactions complete 👍")
            completion(1, 1)
        }
    }
}
