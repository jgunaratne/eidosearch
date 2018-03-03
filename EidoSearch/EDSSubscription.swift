//
//  EDSSubscription.swift
//  EidoSearch
//
//  Created by Junius Gunaratne on 3/15/17.
//  Copyright © 2017 Junius Gunaratne. All rights reserved.
//

import UIKit
import StoreKit

class EDSSubscription: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
  
  var productID:NSSet = NSSet(object: "EIDOAPP1")
  var productsRequest:SKProductsRequest = SKProductsRequest()
  var products = [String : SKProduct]()
  

  public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
    
  }

  public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
  
  }

}
