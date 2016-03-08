//: Playground - noun: a place where people can play

import UIKit
import Foundation

// 프로토콜 앞에 붙은 @objc는 특정 객체를 다운캐스트해서 Pool 클래스에서 canReuse 속성을 읽을 수 있게 하기 위함
@objc protocol PoolItem {
    var canReuse: Bool {get}
}

@objc class Book: NSObject, PoolItem {
    let author:String
    let title:String
    let stockNumber:Int
    var reader:String?
    var checkoutCount = 0
    
    init(author:String, title:String, stock:Int) {
        self.author = author
        self.title = title
        self.stockNumber = stock
        super.init()
    }
    
    var canReuse:Bool {
        get {
            let reusable = checkoutCount < 5
            if (!reusable) {
                print("EJECT: BOOK# \(self.stockNumber)")
            }
            return reusable
        }
    }
}

class BookSeller {
    class func buyBook(author:String, title:String, stockNumber:Int) -> Book {
        return Book(author: author, title: title, stock: stockNumber)
    }
}


class Pool<T:AnyObject> {
    private var data = [T]()
    private let arrayQ = dispatch_queue_create("arrayQ", DISPATCH_QUEUE_SERIAL); private let semaphore:dispatch_semaphore_t;
    private var itemCount = 0
    private let maxItemCount:Int
    private let itemFactory: () -> T
    
    // 최대 아이템 갯수, 풀을 위해 새로운 객체를 생성하는 클로져를 전달받도록 수정함.
    init(maxItemCount:Int, factory:() -> T) {
        self.itemFactory = factory
        self.maxItemCount = maxItemCount
        semaphore = dispatch_semaphore_create(maxItemCount)
    }
    
    func getFromPool() -> T? {
        var result:T?;
        if (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER) == 0) {
            dispatch_sync(arrayQ, { () in
                if (self.data.count == 0 && self.itemCount < self.maxItemCount) {
                    result = self.itemFactory()
                    self.itemCount++
                } else {
                    result = self.data.removeAtIndex(0)
                }
            })
        }
        return result
    }
    
    func returnToPool(item:T) {
        dispatch_async(arrayQ, {() in
            let pItem = item as AnyObject as? PoolItem
            //nil체크가 아니라, PoolItem 구현체가 아닌 것을 의미,
            //즉, PoolItem의 구현체가 아니거나, 혹시 구현체이면 canReuse가 true인 애들만 풀에 삽입
            if (pItem == nil || pItem!.canReuse) {
                self.data.append(item)
                dispatch_semaphore_signal(self.semaphore)
            }
        })
    }
    
    func processPoolItems(callback:[T] -> Void) {
        dispatch_barrier_sync(arrayQ, {() in
            callback(self.data);
        });
    }
}



final class Library {
    private let pool:Pool<Book>
    private init(stockLevel:Int) {
        var stockId = 1
        pool = Pool<Book>(maxItemCount: stockLevel, factory: {() in
            return BookSeller.buyBook("Dickens, Charles",
                title: "Hard Times", stockNumber: stockId++)
        });
    }
    private class var singleton:Library {
        struct SingletonWrapper {
            static let singleton = Library(stockLevel:200);
        }
        return SingletonWrapper.singleton
    }
    class func checkoutBook(reader:String) -> Book? {
        let book = singleton.pool.getFromPool()
        book?.reader = reader
        book?.checkoutCount++
        
        return book
    }
    class func returnBook(book:Book) {
        book.reader = nil
        singleton.pool.returnToPool(book)
    }
    class func printReport() {
        singleton.pool.processPoolItems({(books) in
            for book in books {
                print("...Book#\(book.stockNumber)...")
                print("Checked out \(book.checkoutCount) times")
                if (book.reader != nil) {
                    print("Checked out to \(book.reader!)")
                } else {
                    print("In stock")
                }
            }
            print("There are \(books.count) books in the pool")
        });
    }
}

class ElasticPool<T:AnyObject> {
    private var data = [T]();
    private let arrayQ = dispatch_queue_create("arrayQ", DISPATCH_QUEUE_SERIAL);
    private let semaphore:dispatch_semaphore_t;
    private let itemFactory: () -> T;
    private let peakFactory: () -> T;
    private let itemAllocator:[T] -> Int;
    private let peakReaper:(T) -> Void;
    private var createdCount:Int = 0;
    private let normalCount:Int;
    private let peakCount:Int;
    private let returnCount:Int;
    private let waitTime:Int;
    
    init(itemCount:Int, peakCount:Int, returnCount: Int, waitTime:Int = 2,
        itemFactory:() -> T, peakFactory:() -> T, reaper:(T) -> Void, itemAllocator:([T] -> Int)) {
            self.normalCount = itemCount; self.peakCount = peakCount;
            self.waitTime = waitTime; self.returnCount = returnCount;
            self.itemFactory = itemFactory; self.peakFactory = peakFactory;
            self.peakReaper = reaper;
            self.itemAllocator = itemAllocator
            self.semaphore = dispatch_semaphore_create(itemCount);
    }
    func getFromPool() -> T? {
        var result:T?;
        let expiryTime = dispatch_time(DISPATCH_TIME_NOW,
            (Int64(waitTime) * Int64(NSEC_PER_SEC)));
        if (dispatch_semaphore_wait(semaphore, expiryTime) == 0) {
            dispatch_sync(arrayQ, {() in
                if (self.data.count == 0) {
                    result = self.itemFactory();
                    self.createdCount++;
                } else {
                    result = self.data.removeAtIndex(self.itemAllocator(self.data))
                } })
        } else {
            dispatch_sync(arrayQ, {() in
                result = self.peakFactory();
                self.createdCount++;
            });
        }
        return result;
    }
    func returnToPool(item:T) {
        dispatch_async(arrayQ, {() in
            if (self.data.count > self.returnCount
                && self.createdCount > self.normalCount) {
                    self.peakReaper(item);
                    self.createdCount--;
            } else {
                self.data.append(item);
                dispatch_semaphore_signal(self.semaphore);
            }
        }); }
    func processPoolItems(callback:[T] -> Void) {
        dispatch_barrier_sync(arrayQ, {() in
            callback(self.data);
        });
    }
}

class LibraryNetwork {
    class func borrowBook(author:String, title:String, stockNumber:Int) -> Book {
        return Book(author: author, title: title, stock: stockNumber);
    }
    class func returnBook(book:Book) {
        // do nothing
    }
}

final class LibraryUseElasticPool {
    private let pool:ElasticPool<Book>
    private init(stockLevel:Int) {
        var stockId = 1
        pool = ElasticPool<Book>(itemCount:stockLevel,
            peakCount: stockLevel * 2,
            returnCount: stockLevel / 2,
            itemFactory: {() in
                return BookSeller.buyBook("Dickens, Charles",
                    title: "Hard Times", stockNumber: stockId++)},
            peakFactory: {() in
                return LibraryNetwork.borrowBook("Dickens, Charles",
                    title: "Hard Times", stockNumber: stockId++)},
            reaper: LibraryNetwork.returnBook,
            itemAllocator: {(var books) in
                var selected = 0;
                for index in 1 ..< books.count {
                    if (books[index].checkoutCount < books[selected].checkoutCount) {
                        selected = index;
                    }
                }
                return selected;
        }); //{(let books) in return 0 }이런 클로져라면 동일한 기능
    }
    private class var singleton:Library {
        struct SingletonWrapper {
            static let singleton = Library(stockLevel:200);
        }
        return SingletonWrapper.singleton
    }
    class func checkoutBook(reader:String) -> Book? {
        let book = singleton.pool.getFromPool()
        book?.reader = reader
        book?.checkoutCount++
        
        return book
    }
    class func returnBook(book:Book) {
        book.reader = nil
        singleton.pool.returnToPool(book)
    }
    class func printReport() {
        singleton.pool.processPoolItems({(books) in
            for book in books {
                print("...Book#\(book.stockNumber)...")
                print("Checked out \(book.checkoutCount) times")
                if (book.reader != nil) {
                    print("Checked out to \(book.reader!)")
                } else {
                    print("In stock")
                }
            }
            print("There are \(books.count) books in the pool")
        });
    }
}



var queue = dispatch_queue_create("workQ", DISPATCH_QUEUE_CONCURRENT);
var group = dispatch_group_create();

print("Starting...");

for i in 1 ... 35 {
    dispatch_group_async(group, queue, {() in
        var book = LibraryUseElasticPool.checkoutBook("reader#\(i)");
        if (book != nil) {
            NSThread.sleepForTimeInterval(Double(rand() % 2));
            LibraryUseElasticPool.returnBook(book!);
        } else {
            dispatch_barrier_async(queue, {() in
                print("Request \(i) failed");
            });
        }
    });
}

dispatch_group_wait(group, DISPATCH_TIME_FOREVER);

dispatch_barrier_sync(queue, {() in
    print("All blocks complete");
    LibraryUseElasticPool.printReport();
});

