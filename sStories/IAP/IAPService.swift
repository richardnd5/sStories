import Foundation
import StoreKit

class workingIAPProduct : NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    static var shared = workingIAPProduct()
    
    var list = [SKProduct]()
    var currentProduct = SKProduct()

    func setupIAP(){
        
        if(SKPaymentQueue.canMakePayments()) {
            print("IAP is enabled, loading")
            let productID : NSSet = NSSet(objects: IAPProduct.oneDollarDonation.rawValue, IAPProduct.twentyDollarDonation.rawValue, IAPProduct.fiveDollarDonation.rawValue, IAPProduct.tenDollarDonation.rawValue)
            let request : SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>)
            
            request.delegate = self
            request.start()
            
        } else {
            print("please enable IAPS")
        }
        
    }
    
    func makePurchase(productType: IAPProduct){
        for product in list {
            let prodID = product.productIdentifier
            if (prodID == productType.rawValue){
                currentProduct = product
                buyProduct()
            }
        }
    }
    
    private func buyProduct(){
        print("buy \(currentProduct.productIdentifier)")
        let pay = SKPayment(product: currentProduct)
        SKPaymentQueue().add(self)
        SKPaymentQueue.default().add(pay as SKPayment)
        
    }
    
    func restorePurchases(){
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("product request")
        let myProduct = response.products
        for product in myProduct {
            print("product added")
            print(product.productIdentifier)
            print(product.localizedTitle)
            print(product.localizedDescription)
            print(product.price)
            
            list.append(product)
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        print("transactions restored")
        for transaction in queue.transactions {
            let t : SKPaymentTransaction = transaction
            let prodID = t.payment.productIdentifier as String
            
            switch prodID {
            case IAPProduct.oneDollarDonation.rawValue : print("one dollar donation")
            case IAPProduct.twentyDollarDonation.rawValue : print("twenty dollar donation")
            case IAPProduct.fiveDollarDonation.rawValue : print("five dollar donation")
            case IAPProduct.tenDollarDonation.rawValue : print("ten dollar donation")
            default:
                print("what?")
            }
        }
    }

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("add payment")
        
        for transaction : AnyObject in transactions {
            let trans = transaction as! SKPaymentTransaction
            //            print(trans.error)
            
            switch trans.transactionState {
            case .purchased:
                print("PURSHAED")
                print(currentProduct.productIdentifier)
                
                
                let prodID = currentProduct.productIdentifier
                switch prodID {
                case IAPProduct.oneDollarDonation.rawValue : print("one dollar donation")
                case IAPProduct.twentyDollarDonation.rawValue : print("twenty dollar donation")
                case IAPProduct.fiveDollarDonation.rawValue : print("five dollar donation")
                case IAPProduct.tenDollarDonation.rawValue : print("ten dollar donation")
                default:
                    print("what?")
                }
            //                queue.finishTransaction(trans)
            case .failed:
                print("buy error")
                queue.finishTransaction(trans)
                break
            default:
                print("Default")
                break
            }
            
            
        }
    }
}
