//: Playground - noun: a place where people can play

import UIKit

class Keyboard {
    var price: Int
    var power: Int
    
    init(price: Int, power: Int) {
        self.price = price
        self.power = power
    }
}

class Body {
    var price: Int
    var power: Int
    
    init(price: Int, power: Int) {
        self.price = price
        self.power = power
    }
}

class Monitor {
    var price: Int
    var power: Int
    
    init(price: Int, power: Int) {
        self.price = price
        self.power = power
    }
}

class Computer {
    var body: Body?
    var keyboard: Keyboard?
    var monitor: Monitor?
    
    init(body: Body, keyboard: Keyboard, monitor: Monitor) {
        self.body = body
        self.keyboard = keyboard
        self.monitor = monitor
    }
    
    func getPrice() -> Int {
        var bodyPrice: Int = 0
        var keyboardPrice: Int = 0
        var monitorPrice: Int = 0
        
        if let price = self.body?.price {
            bodyPrice = price
        }
        if let price = self.keyboard?.price {
            keyboardPrice = price
        }
        if let price = self.monitor?.price {
            monitorPrice = price
        }
        
        return bodyPrice + keyboardPrice + monitorPrice
    }
    
    func getPower() -> Int {
        var bodyPower: Int = 0
        var keyboardPower: Int = 0
        var monitorPower: Int = 0
        
        if let power = self.body?.power {
            bodyPower = power
        }
        if let power = self.keyboard?.power {
            keyboardPower = power
        }
        if let power = self.monitor?.power {
            monitorPower = power
        }
        
        return bodyPower + keyboardPower + monitorPower
    }
    
}

var body: Body = Body(price:100, power:70)
var keyboard: Keyboard = Keyboard(price: 5, power:2)
var monitor: Monitor = Monitor(price: 20, power:30)
var computer: Computer = Computer(body: body, keyboard: keyboard, monitor: monitor)

print("Computer power: \(computer.getPower()), price: \(computer.getPrice())")

/*
 * 현재는 본체, 키보드, 모니터 객체로 구성되었지만 스피커가 추가된다면? 마우스라도 추가된다면? => 다른 부품과 비슷한 중복 코드가 증가하게 된다.
 *
 */