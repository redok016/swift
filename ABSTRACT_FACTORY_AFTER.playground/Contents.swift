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

class ElevatorFactory {
    
    func createMotor() -> Motor {
         fatalError("SHOULD BE OVERRIDDEN IN A SUBCLASS")
    }
    
    func createDoor() -> Door {
         fatalError("SHOULD BE OVERRIDDEN IN A SUBCLASS")
    }
}

class LGElevatorFactory: ElevatorFactory {
    
    static let sharedInstance: LGElevatorFactory = {
        let instance = LGElevatorFactory()
        // setup code
        return instance
    }()
    
    override func createMotor() -> Motor {
        return LGMotor()
    }
    
    override func createDoor() -> Door {
        return LGDoor()
    }
}

class HyundaiElevatorFactory: ElevatorFactory {
    
    static let sharedInstance: HyundaiElevatorFactory = {
        let instance = HyundaiElevatorFactory()
        // setup code
        return instance
    }()

    
    override func createMotor() -> Motor {
        return HyundaiMotor()
    }
    
    override func createDoor() -> Door {
        return HyundaiDoor()
    }
}

class ElevatorFactoryManager {
    
    class func getFactory(vendorID id: VendorID) -> ElevatorFactory {
        var elevatorFactory: ElevatorFactory
        
        switch (id) {
        case VendorID.LG:
            elevatorFactory = LGElevatorFactory.sharedInstance
            break
        case VendorID.HYUNDAI:
            elevatorFactory = HyundaiElevatorFactory.sharedInstance
            break
        }
        
        return elevatorFactory
    }
}

var elevatorFactory: ElevatorFactory = ElevatorFactoryManager.getFactory(vendorID: .LG)
var door: Door = elevatorFactory.createDoor()
var motor: Motor = elevatorFactory.createMotor()
motor.door = door

door.open()
motor.move(.UP)

