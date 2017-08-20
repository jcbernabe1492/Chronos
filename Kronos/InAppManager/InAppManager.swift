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
    
    

//MARK: - SKProducts Request Delegate
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
    }
    
//MARK: - SKPayment Transactions Observer
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
    }
}
