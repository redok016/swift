//: Playground - noun: a place where people can play

import UIKit

enum Direction {
    case UP
    case DOWN
}

class ElevatorController {
    var id: Int
    var currentFloor: Int
    
    init(id: Int) {
        self.id = id
        self.currentFloor = 1
    }
    
    func moveToFloorAt(destinationFloor floor: Int) {
        print("Elevator [\(self.id)] CurrentFloor: \(self.currentFloor)")
        self.currentFloor = floor
        print("=====> Move To \(self.currentFloor)")
    }
}

protocol ElevatorScheduler {
    func selectElevator(elevatorManager manager: ElevatorManager,
        destinationFloor floor: Int,
        direction dir: Direction) ->Int
}

class ThroughputScheduler: ElevatorScheduler {
    func selectElevator(elevatorManager manager: ElevatorManager,
        destinationFloor floor: Int,
        direction dir: Direction) -> Int {
            return 0
    }
}

class ResponseTimeScheduler: ElevatorScheduler {
    func selectElevator(elevatorManager manager: ElevatorManager,
        destinationFloor floor: Int,
        direction dir: Direction) -> Int {
            return 1
    }
}

class ElevatorManager {
    
    var elevatorControllers: [ElevatorController]
    
    init(controllerCount: Int) {
        self.elevatorControllers = [ElevatorController]()
        for (var index: Int = 0; index < controllerCount; index++) {
            let elevatorController: ElevatorController = ElevatorController(id: index)
            self.elevatorControllers.append(elevatorController)
        }
    }
    
    func getScheduler() ->ElevatorScheduler {
        fatalError("SHOULD BE OVERRIDEN BY SUBCLASS")
    }
    
    func requestElevator(destinationFloor: Int, direction: Direction) {
        let elevatorScheduler: ElevatorScheduler = self.getScheduler()
        print("Current Scheduler: \(elevatorScheduler)")
        
        let selectedElevator: Int = elevatorScheduler.selectElevator(elevatorManager: self, destinationFloor: destinationFloor, direction: direction)
        self.elevatorControllers[selectedElevator].moveToFloorAt(destinationFloor: destinationFloor)
    }
}

class ElevatorManagerWithThroughputScheduler: ElevatorManager {
    
    override func getScheduler() -> ElevatorScheduler {
        return ThroughputScheduler()
    }
}

class ElevatorManagerWithResponseTimeScheduler: ElevatorManager {
    
    override func getScheduler() -> ElevatorScheduler {
        return ResponseTimeScheduler()
    }
}

class ElevatorManagerWithDynamicScheduler: ElevatorManager {
    
    override func getScheduler() -> ElevatorScheduler {
        let hour = NSCalendar.currentCalendar().component(.Hour, fromDate: NSDate())
        
        if hour < 12 {
            return ResponseTimeScheduler()
        } else {
            return ThroughputScheduler()
        }
    }
}

var elevatorManager1: ElevatorManager = ElevatorManagerWithThroughputScheduler(controllerCount: 2)
var elevatorManager2: ElevatorManager = ElevatorManagerWithResponseTimeScheduler(controllerCount: 2)
var elevatorManager3: ElevatorManager = ElevatorManagerWithDynamicScheduler(controllerCount: 2)

elevatorManager1.requestElevator(10, direction: Direction.UP)
elevatorManager2.requestElevator(8, direction: Direction.UP)
elevatorManager3.requestElevator(8, direction: Direction.UP)

/*
* 위와 같이 하위 클래스에서 적합한 클래스를 생성할 수 있도록 메소드를 제공하는 방식으로도 변경 가능
*/
