//: Playground - noun: a place where people can play

import UIKit

class Purchase: CustomStringConvertible {
    private let product: String
    private let price: Float
    
    init(product: String, price: Float) {
        self.product = product
        self.price = price
    }
    
    var description: String {
        return product
    }
    
    var totalPrice: Float {
        return price
    }
}


class CustomerAccount {
    let customerName: String
    var purchases = [Purchase]()
    
    init(name: String) {
        self.customerName = name
    }
    
    func addPurchase(purchase: Purchase) {
        self.purchases.append(purchase)
    }
    
    func printAccount() {
        var total: Float = 0
        for purchase in purchases {
            total += purchase.totalPrice
            print("Purchase: \(purchase), Price \(formatCurrencyString(purchase.totalPrice))")
        }
        print("Total due: \(formatCurrencyString(total))")
    }
    
    func formatCurrencyString(number:Float) -> String {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        return formatter.stringFromNumber(number) ?? ""
    }
    
}

let account = CustomerAccount(name:"Joe");
account.addPurchase(Purchase(product: "Red Hat", price: 10));
account.addPurchase(Purchase(product: "Scarf", price: 20));
account.printAccount();

// Purchase와 CustomerAccount 클래스 수정 없이 선물에 대한 옵션을 추가하는 경우를 생각해보자.
// 1차적으로 Purchase 클래스를 상속받을 생각을 할 것이다. 아래와 같이 말이다.

class PurchaseWithGiftWrap : Purchase {
    override var description:String { return "\(super.description) + giftwrap" }
    override var totalPrice:Float { return super.totalPrice + 2 }
}
class PurchaseWithRibbon : Purchase {
    override var description:String { return "\(super.description) + ribbon" }
    override var totalPrice:Float { return super.totalPrice + 1 }
}
class PurchaseWithDelivery : Purchase {
    override var description:String { return "\(super.description) + delivery" }
    override var totalPrice:Float { return super.totalPrice + 5 }
}
class PurchaseWithGiftWrapAndDelivery : Purchase {
    override var description:String {
        return "\(super.description) + giftwrap + delivery" }
    override var totalPrice:Float { return super.totalPrice + 5 + 2 }
}

// 옵션이 증가하면 할 수록 위와 같은 상속받은 클래스가 증가할 것이다.