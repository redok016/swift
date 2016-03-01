//: Playground - noun: a place where people can play

import UIKit

protocol ComputerDevice {
    var price: Int{ get set }
    var power: Int{ get set }
    
    func addComponent(component: ComputerDevice)
}

class Keyboard: ComputerDevice {
    var price: Int
    var power: Int
    
    init(price: Int, power: Int) {
        self.price = price
        self.power = power
    }
    
    func addComponent(component: ComputerDevice) {
        fatalError("DO NOT SUPPORT")
    }
}

class Body: ComputerDevice {
    var price: Int
    var power: Int
    
    init(price: Int, power: Int) {
        self.price = price
        self.power = power
    }

    func addComponent(component: ComputerDevice) {
        fatalError("DO NOT SUPPORT")
    }
    
}

class Monitor: ComputerDevice {
    var price: Int
    var power: Int
    
    init(price: Int, power: Int) {
        self.price = price
        self.power = power
    }
    
    func addComponent(component: ComputerDevice) {
        fatalError("DO NOT SUPPORT")
    }
    
}

class Computer: ComputerDevice {
    
    var computerPrice: Int
    var computerPower: Int
    var components:[ComputerDevice]
    
    var price: Int {
        get {
            var totalPrice: Int = 0
            for  component in self.components  {
                totalPrice += component.price
            }
            
            return totalPrice
        }
        set(newValue) {
            computerPrice = newValue
        }
    }
    
    var power: Int {
        get {
            var totalPower: Int = 0
            for component in self.components {
                totalPower += component.power
            }
            
            return totalPower
        }
        set(newValue) {
            computerPower = newValue
        }
    }
    
    init() {
        self.computerPrice = 0
        self.computerPower = 0
        self.components = [ComputerDevice]()
        
        self.price = 0
        self.power = 0

    }
    
    func addComponent(component: ComputerDevice) {
        self.components.append(component)
    }
    
}

var body: Body = Body(price:100, power:70)
var keyboard: Keyboard = Keyboard(price: 5, power:2)
var monitor: Monitor = Monitor(price: 20, power:30)

var computer: Computer = Computer()

computer.addComponent(body)
computer.addComponent(keyboard)
computer.addComponent(monitor)

print("Computer power: \(computer.power), price: \(computer.price)")

/* 
 * 부분-전체의 관계를 갖는 객체들 사이를 정의할 때 유용. 클라이언트는 전체와 부분을 구분하지 않고 동일한 인터페이스로 사용 가능 
 */
