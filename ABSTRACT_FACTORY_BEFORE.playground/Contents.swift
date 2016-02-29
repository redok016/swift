//: Playground - noun: a place where people can play

import UIKit

enum MotorStatus {
    case MOVING
    case STOPPED
}

enum DoorStatus {
    case CLOSED
    case OPENED
}

enum Direction {
    case UP
    case DOWN
}

enum VendorID {
    case LG
    case HYUNDAI
}

class Door {
    
    var doorStatus: DoorStatus
    
    init() {
        self.doorStatus = DoorStatus.CLOSED
    }
    
    func open() {
        if (self.doorStatus == DoorStatus.OPENED) {
            return
        }
        
        doOpen()
        self.doorStatus = DoorStatus.OPENED
    }
    
    func close() {
        if (self.doorStatus == DoorStatus.CLOSED) {
            return
        }
        
        doClose()
        self.doorStatus = DoorStatus.CLOSED
        
    }
    
    func doOpen() {
    }
    
    func doClose() {
    }
}

class Motor {
    
    var motorStatus: MotorStatus
    var door: Door?
    
    init() {
        self.motorStatus = MotorStatus.STOPPED
    }
    
    func move(direction: Direction) {
        if (self.motorStatus == MotorStatus.MOVING) {
            return
        }
        
        let doorStatus: DoorStatus? = self.door?.doorStatus
        if (doorStatus == DoorStatus.OPENED) {
            self.door?.close()
        }
        
        self.moveMotor(direction)
        self.motorStatus = MotorStatus.MOVING
    }
    
    func moveMotor(direction: Direction) {
    }
}

class LGMotor: Motor {
    
    override func moveMotor(direction: Direction) {
        print("MOVE LG MOTOR")
    }
}

class HyundaiMotor: Motor {
    
    override func moveMotor(direction: Direction) {
        print("MOVE HYUNDAI MOTOR")
    }
}

class LGDoor: Door {
    
    override func doClose() {
        print("CLOSE LG DOOR")
    }
    
    override func doOpen() {
        print("OPEN LG DOOR")
    }
}

class HyundaiDoor: Door {
    
    override func doClose() {
        print("CLOSE HYUNDAI DOOR")
    }
    
    override func doOpen() {
        print("OPEN HYUNDAI DOOR")
    }
}

class MotorFactory {
    
    class func createMotor(vendorID id: VendorID) -> Motor {
        var motor: Motor
        
        switch (id) {
        case VendorID.LG:
            motor = LGMotor()
            break
        case VendorID.HYUNDAI:
            motor = HyundaiMotor()
            break
        }
        return motor
    }
}

class DoorFactory {
    
    class func createDoor(vendorID id: VendorID) -> Door {
        var door : Door
        switch (id) {
        case VendorID.LG:
            door = LGDoor()
            break
        case VendorID.HYUNDAI:
            door = HyundaiDoor()
            break
        }
        
        return door
    }
}


var lgDoor: Door = DoorFactory.createDoor(vendorID: VendorID.LG)
var lgMotor: Motor = MotorFactory.createMotor(vendorID: VendorID.LG)
lgMotor.door = lgDoor

lgDoor.open()
lgMotor.move(Direction.UP)

var hyundaiDoor: Door = DoorFactory.createDoor(vendorID: VendorID.HYUNDAI)
var hyundaiMotor: Motor = MotorFactory.createMotor(vendorID: VendorID.HYUNDAI)
hyundaiMotor.door = hyundaiDoor

hyundaiDoor.open()
hyundaiMotor.move(Direction.UP)

/*
- LG의 부품을 사용하는데 다른 제조 업체의 부품을 사용해야 한다면? (ex. LG 부품 대신 현대 부품을 사용해야하는 경우)
- 새로운 업체의 부품을 지원해야 한다면? (ex. 삼성에서 엘레베이터 부품을 생산하기 시작해 삼성의 부품을 지원해야 하는 경우)
*/

