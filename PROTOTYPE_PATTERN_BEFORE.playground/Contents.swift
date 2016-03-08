//: Playground - noun: a place where people can play

import UIKit

class Sum {
    var resultsCache: [[Int]];
    var firstValue:Int;
    var secondValue:Int;
    init(first:Int, second:Int) {
        resultsCache = [[Int]](count: 10, repeatedValue:
            [Int](count:10, repeatedValue: 0));
        for i in 0..<10 {
            for j in 0..<10 {
                resultsCache[i][j] = i + j;
            }
        }
        self.firstValue = first;
        self.secondValue = second;
    }
    var Result:Int {
        get {
            return firstValue < resultsCache.count
                && secondValue < resultsCache[firstValue].count
                ? resultsCache[firstValue][secondValue]
                : firstValue + secondValue;
        }
    } }
var calc1 = Sum(first:0, second: 9).Result;
var calc2 = Sum(first:3, second: 8).Result;

print("Calc1: \(calc1) Calc2: \(calc2)");

//Sum객체를 생성할 때마다 이차원 배열 resultCache을 할당하고 조작하는데 비용이 소모됨 NSCopying을 통해 프로토타입 패턴을 사용해보자

class Sum2 : NSObject, NSCopying {
    var resultsCache: [[Int]];
    var firstValue:Int;
    var secondValue:Int;
    init(first:Int, second:Int) {
        resultsCache = [[Int]](count: 10, repeatedValue:
            [Int](count:10, repeatedValue: 0));
        for i in 0..<10 {
            for j in 0..<10 {
                resultsCache[i][j] = i + j;
            }
        }
        self.firstValue = first;
        self.secondValue = second;
    }
    private init(first:Int, second:Int, cache:[[Int]]) {
        self.firstValue = first;
        self.secondValue = second;
        resultsCache = cache;
    }
    var Result:Int {
        get {
            return firstValue < resultsCache.count
                && secondValue < resultsCache[firstValue].count
                ? resultsCache[firstValue][secondValue]
                : firstValue + secondValue;
        }
    }

    func copyWithZone(zone: NSZone) -> AnyObject {
        return Sum2(first: self.firstValue, second: self.secondValue, cache: self.resultsCache)
    }
}

var prototype = Sum2(first:0, second:9);
var calc3 = prototype.Result;
var clone = prototype.copy() as! Sum2;
clone.firstValue = 3
clone.secondValue = 8;
var calc4 = clone.Result;

print("Calc3: \(calc3) Calc4: \(calc4)");

class Message {
    var to: String
    var subject: String
    
    init(to: String, subject: String) {
        self.to = to
        self.subject = subject
    }
}

class MessageLogger {
    var messages: [Message]
    
    init() {
        messages = [Message]()
    }
    
    func logMessage(msg: Message) {
        messages.append(Message(to: msg.to, subject: msg.subject))
    }
    
    func processMessages(callback: Message -> Void) {
        for msg in self.messages {
            callback(msg)
        }
    }
}

var logger: MessageLogger = MessageLogger()
var message: Message = Message(to: "Joe", subject: "Hello")

logger.logMessage(message)
message.to = "Bob"
message.subject = "Free for dinner?"
logger.logMessage(message)

logger.processMessages { (message) -> Void in
    print("Message - To: \(message.to) Subject: \(message.subject)")
}

//위 상황에서 Message타입이 하나 추가될 경우(DetailMessage)

class DetailMessage: Message {
    var from: String
    
    init(to: String, subject: String, from: String) {
        self.from = from
        super.init(to: to, subject: subject)
    }
}


// 사용하는 입장에서는 아래와 같은 수정이 불가피 함

logger.logMessage(DetailMessage(to: "Alice", subject: "Hi!", from: "Joe"));
logger.processMessages({msg -> Void in
    if let detailed = msg as? DetailMessage {
        print("Detailed Message - To: \(detailed.to) From: \(detailed.from)"
            + " Subject: \(detailed.subject)");
    } else {
        print("Message - To: \(msg.to) Subject: \(msg.subject)");
    }
});

// 물론 logMessages()메소드 내부에서 append를 분기처리하는 방법이 있겠다.
// 하지만 이게 근본적인 해결책일까?


