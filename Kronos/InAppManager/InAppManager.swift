//
//  InAppManager.swift
//  Kronos
//
//  Created by John Christopher Bernabe on 19/08/2017.
//  Copyright © 2017 davidwee. All rights reserved.
//

import Foundation
import StoreKit

class InAppManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    static var sharedInstance = InAppManager()
    
    let CHRONO_ONE_PRODUCT_ID = "com.scdb.chrono.one"
    let CHRONO_PRO_PRODUCT_ID = "com.scdb.chrono.pro"
    
    var productsRequest = SKProductsRequest()
    var iapProducts = [SKProduct]()
    var productID = ""
    
    func fetchAvailableProducts() {
        // Put here your IAP Products ID's
        let productIdentifiers = NSSet(objects:
            CHRONO_ONE_PRODUCT_ID,
            CHRONO_PRO_PRODUCT_ID
        )
        
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
        productsRequest.delegate = self
        productsRequest.start()
    }

//MARK: - SKProducts Request Delegate
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        if (response.products.count > 0) {
            iapProducts = response.products
            
            // 1st IAP Product (Consumable) ------------------------------------
            let firstProduct = response.products[0] as SKProduct
            
            // Get its price from iTunes Connect
            let numberFormatter = NumberFormatter()
            numberFormatter.formatterBehavior = .behavior10_4
            numberFormatter.numberStyle = .currency
            numberFormatter.locale = firstProduct.priceLocale
            let price1Str = numberFormatter.string(from: firstProduct.price)
            
            print(price1Str!)
            
            // Show its description
            //consumableLabel.text = firstProduct.localizedDescription + "\nfor just \(price1Str!)"
            // ------------------------------------------------
            
            
            
            // 2nd IAP Product (Non-Consumable) ------------------------------
            let secondProd = response.products[1] as SKProduct
            
            // Get its price from iTunes Connect
            numberFormatter.locale = secondProd.priceLocale
            let price2Str = numberFormatter.string(from: secondProd.price)
            
            print(price2Str!)
            // Show its description
            //nonConsumableLabel.text = secondProd.localizedDescription + "\nfor just \(price2Str!)"
            // ------------------------------------
        }
        
    }
    
// MARK: - MAKE PURCHASE OF A PRODUCT
    func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }
    func purchaseMyProduct(product: SKProduct) {
        if self.canMakePurchases() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
            
            print("PRODUCT TO PURCHASE: \(product.productIdentifier)")
            productID = product.productIdentifier
            
            
            // IAP Purchases dsabled on the Device
        } else {
//            UIAlertView(title: "IAP Tutorial",
//                        message: "Purchases are disabled in your device!",
//                        delegate: nil, cancelButtonTitle: "OK").show()
        }
    }
    
//MARK: - SKPayment Transactions Observer
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                    
                case .purchased:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    
                    // The Consumale product (10 coins) has been purchased -> gain 10 extra coins!
                    if productID == CHRONO_ONE_PRODUCT_ID {
                        
                        // Add 10 coins and save their total amount
//                        coins += 10
//                        UserDefaults.standard.set(coins, forKey: "coins")
//                        coinsLabel.text = "COINS: \(coins)"
//                        
//                        UIAlertView(title: "IAP Tutorial",
//                                    message: "You've successfully bought 10 extra coins!",
//                                    delegate: nil,
//                                    cancelButtonTitle: "OK").show()
                        
                        
                        
                        // The Non-Consumable product (Premium) has been purchased!
                    } else if productID == CHRONO_PRO_PRODUCT_ID {
                        
                        // Save your purchase locally (needed only for Non-Consumable IAP)
//                        nonConsumablePurchaseMade = true
//                        UserDefaults.standard.set(nonConsumablePurchaseMade, forKey: "nonConsumablePurchaseMade")
//                        
//                        premiumLabel.text = "Premium version PURCHASED!"
//                        
//                        UIAlertView(title: "IAP Tutorial",
//                                    message: "You've successfully unlocked the Premium version!",
//                                    delegate: nil,
//                                    cancelButtonTitle: "OK").show()
                    }
                    
                    break
                    
                case .failed:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                case .restored:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                    
                default: break
                }
            }
        }
    }
    
    // MARK: - RESTORE NON-CONSUMABLE PURCHASE BUTTON
    @IBAction func restorePurchaseButt(_ sender: Any) {
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
//        nonConsumablePurchaseMade = true
//        UserDefaults.standard.set(nonConsumablePurchaseMade, forKey: "nonConsumablePurchaseMade")
        
//        UIAlertView(title: "IAP Tutorial",
//                    message: "You've successfully restored your purchase!",
//                    delegate: nil, cancelButtonTitle: "OK").show()
    }
}
