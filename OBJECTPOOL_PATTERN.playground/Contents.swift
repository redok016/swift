//: Playground - noun: a place where people can play

import UIKit
import Foundation

class Pool<T> {
    private var data = [T]()
    private let arrayQ = dispatch_queue_create("arrayQ", DISPATCH_QUEUE_SERIAL)
    private let semaphore: dispatch_semaphore_t
    
    init(items:[T]) {
        self.data.reserveCapacity(data.count)
        for item in items {
            self.data.append(item)
        }
        // item의 갯수를 받아 세마포어를 만들고,
        self.semaphore = dispatch_semaphore_create(items.count)
    }
    
    func getFromPool() ->T? {
        var result: T?
        // dispatch_semaphore_wait가 터질 때 마다 세마포어 카운트 감소,
        if (dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER) == 0) {
            dispatch_sync(arrayQ, { () -> Void in
                result = self.data.removeAtIndex(0)
            })
        }
        return result
    }
    
    func returnToPool(item: T) {
        dispatch_async(arrayQ, { () -> Void in
            self.data.append(item)
            // 새로운 아이템이 삽입되면 세마포어 증가 시키는 dispatch_semaphore_signal로 카운트 증가
            dispatch_semaphore_signal(self.semaphore)
        })
    }
}

class NetworkConnection {
    private let stockData: [String: Int] = [
        "Kayak" : 10, "Lifejacket": 14, "Soccer Ball": 32,"Corner Flags": 1,
        "Stadium": 4, "Thinking Cap": 8, "Unsteady Chair": 3,
        "Human Chess Board": 2, "Bling-Bling King":4
    ];
    func getStockLevel(name:String) -> Int? {
        NSThread.sleepForTimeInterval(Double(rand() % 2));
        return stockData[name];
    }
}

final class NetworkPool {
    private let connectionCount = 3
    private var connections = [NetworkConnection]()
    private var semaphore:dispatch_semaphore_t
    private var queue:dispatch_queue_t
    
    private init() {
        for _ in 0 ..< self.connectionCount {
            self.connections.append(NetworkConnection())
        }
        self.semaphore = dispatch_semaphore_create(connectionCount)
        self.queue = dispatch_queue_create("networkpoolQ", DISPATCH_QUEUE_SERIAL)
    }
    
    private func doGetConnection() ->NetworkConnection {
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER)
        var result: NetworkConnection?
        dispatch_sync(self.queue, { () -> Void in
            result = self.connections.removeAtIndex(0)
        })
        return result!
    }
    
    private func doReturnConnection(conn: NetworkConnection) {
        dispatch_async(self.queue, { () -> Void in
            self.connections.append(conn)
            dispatch_semaphore_signal(self.semaphore)
        })
    }
    
    class func getConnection() ->NetworkConnection {
        return sharedInstance.doGetConnection()
    }
    
    class func returnConnection(conn: NetworkConnection) {
        sharedInstance.doReturnConnection(conn)
    }
    
    private class var sharedInstance: NetworkPool {
        get {
            struct SingltonWrapper {
                static let singleton = NetworkPool()
            }
            return SingltonWrapper.singleton
        }
    }
}

class Product {
    private(set) var name:String;
    private(set) var description:String;
    private(set) var category:String;
    private var stockLevelBackingValue:Int = 0;
    private var priceBackingValue:Double = 0;
    init(name:String, description:String, category:String, price:Double,
        stockLevel:Int) {
            self.name = name;
            self.description = description;
            self.category = category;
            self.price = price;
            self.stockLevel = stockLevel;
    }
    var stockLevel:Int {
        get { return stockLevelBackingValue;}
        set { stockLevelBackingValue = max(0, newValue);}
    }
    private(set) var price:Double {
        get { return priceBackingValue;}
        set { priceBackingValue = max(1, newValue);}
    }
    var stockValue:Double {
        get {
            return price * Double(stockLevel);
        }
    } }

final class ProductDataStore {
    var callback:((Product) -> Void)?;
    private var networkQ:dispatch_queue_t
    private var uiQ:dispatch_queue_t;
    lazy var products:[Product] = self.loadData();
    init() {
        networkQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
        uiQ = dispatch_get_main_queue();
    }
    private func loadData() -> [Product] {
        for p in productData {
            dispatch_async(self.networkQ, {() in
                let stockConn = NetworkPool.getConnection();
                let level = stockConn.getStockLevel(p.name);
                if (level != nil) {
                    p.stockLevel = level!;
                    dispatch_async(self.uiQ, {() in
                        if (self.callback != nil) {
                            self.callback!(p);
                        } })
                }
                NetworkPool.returnConnection(stockConn);
            });
        }
        return productData;
    }
    private var productData:[Product] = [
        Product(name:"Kayak", description:"A boat for one person",
            category:"Watersports", price:275.0, stockLevel:0),
        Product(name:"Lifejacket", description:"Protective and fashionable",
            category:"Watersports", price:48.95, stockLevel:0),
        Product(name:"Soccer Ball", description:"FIFA-approved size and weight",
            category:"Soccer", price:19.5, stockLevel:0),
        Product(name:"Corner Flags",
            description:"Give your playing field a professional touch",
            category:"Soccer", price:34.95, stockLevel:0),
        Product(name:"Stadium", description:"Flat-packed 35,000-seat stadium",
            category:"Soccer", price:79500.0, stockLevel:0),
        Product(name:"Thinking Cap", description:"Improve your brain efficiency",
            category:"Chess", price:16.0, stockLevel:0),
        Product(name:"Unsteady Chair",
            description:"Secretly give your opponent a disadvantage",
            category: "Chess", price: 29.95, stockLevel:0),
        Product(name:"Human Chess Board", description:"A fun game for the family",
            category:"Chess", price:75.0, stockLevel:0),
        Product(name:"Bling-Bling King",
            description:"Gold-plated, diamond-studded King",
            category:"Chess", price:1200.0, stockLevel:0)];
}