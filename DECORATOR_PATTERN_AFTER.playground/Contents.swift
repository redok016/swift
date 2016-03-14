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

class BasePurchaseDecorator: Purchase {
    private let wrappedPurchase: Purchase
    
    init(purchase: Purchase) {
        wrappedPurchase = purchase
        super.init(product: purchase.description, price: purchase.totalPrice)
    }
}

class PurchaseWithGiftWrap : BasePurchaseDecorator {
    override var description:String { return "\(super.description) + giftwrap" }
    override var totalPrice:Float { return super.totalPrice + 2 }
}
class PurchaseWithRibbon : BasePurchaseDecorator {
    override var description:String { return "\(super.description) + ribbon" }
    override var totalPrice:Float { return super.totalPrice + 1 }
}
class PurchaseWithDelivery : BasePurchaseDecorator {
    override var description:String { return "\(super.description) + delivery" }
    override var totalPrice:Float { return super.totalPrice + 5 }
}

let account = CustomerAccount(name:"Joe")
account.addPurchase(Purchase(product: "Red Hat", price: 10))
account.addPurchase(Purchase(product: "Scarf", price: 20))
account.addPurchase(PurchaseWithDelivery(purchase:PurchaseWithGiftWrap(purchase:Purchase(product: "Sunglasses", price:25))))
account.printAccount()

// 추가적인 기능을 제공하는 Decorator
class DiscountDecorator: Purchase {
    private let wrappedPurchase:Purchase
    init(purchase:Purchase) {
        self.wrappedPurchase = purchase
        super.init(product: purchase.description, price: purchase.totalPrice)
    }
    override var description:String {
        return super.description
    }
    var discountAmount:Float {
        return 0
    }
    func countDiscounts() -> Int {
        var total = 1
        if let discounter = wrappedPurchase as? DiscountDecorator {
            total += discounter.countDiscounts()
        }
        return total
    }
}

class BlackFridayDecorator : DiscountDecorator {
    override var totalPrice:Float {
        return super.totalPrice - discountAmount
    }
    override var discountAmount:Float {
        return super.totalPrice * 0.20
    }
}

class EndOfLineDecorator : DiscountDecorator {
    override var totalPrice:Float {
        return super.totalPrice - discountAmount
    }
    override var discountAmount:Float {
        return super.totalPrice * 0.70
    }
}

let account2 = CustomerAccount(name:"Joe");
account2.addPurchase(Purchase(product: "Red Hat", price: 10))
account2.addPurchase(Purchase(product: "Scarf", price: 20))
account2.addPurchase(EndOfLineDecorator(purchase:BlackFridayDecorator(purchase: PurchaseWithDelivery(purchase:PurchaseWithGiftWrap(purchase:Purchase(product: "Sunglasses", price:25))))))
account2.printAccount()

for purchase in account2.purchases {
    if let discount = purchase as? DiscountDecorator {
        print("\(purchase) has \(discount.countDiscounts()) discounts");
    } else {
        print("\(purchase) has no discounts");
    }
}
