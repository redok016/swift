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

enum SchedulerStartegyID {
    case RESPONSE_TIME
    case THROUGHPUT
    case DYNAMIC
}

class SchedulerFactory {
    class func getScheduler(schedulerStarategy: SchedulerStartegyID) -> ElevatorScheduler {
        
        let elevatorScheduler: ElevatorScheduler
        switch (schedulerStarategy) {
        case .RESPONSE_TIME:
            elevatorScheduler = ResponseTimeScheduler()
            
            break
        case .THROUGHPUT:
            elevatorScheduler = ThroughputScheduler()
            
            break
        case .DYNAMIC:
            let hour = NSCalendar.currentCalendar().component(.Hour, fromDate: NSDate())
            
            if hour < 12 {
                elevatorScheduler = ResponseTimeScheduler()
            } else {
                elevatorScheduler = ThroughputScheduler()
            }

            break
        }
        return elevatorScheduler
    }
}

class ElevatorManager {
    
    var elevatorControllers: [ElevatorController]
    var schedulingStrategyID :SchedulerStartegyID
    
    init(controllerCount: Int, schedulingStrategyID: SchedulerStartegyID) {
        self.elevatorControllers = [ElevatorController]()
        for (var index: Int = 0; index < controllerCount; index++) {
            let elevatorController: ElevatorController = ElevatorController(id: index)
            self.elevatorControllers.append(elevatorController)
        }
        self.schedulingStrategyID = schedulingStrategyID
    }
    
    func requestElevator(destinationFloor: Int, direction: Direction) {
        let elevatorScheduler: ElevatorScheduler = SchedulerFactory.getScheduler(self.schedulingStrategyID)
        print("Current Scheduler: \(elevatorScheduler)")
        
        let selectedElevator: Int = elevatorScheduler.selectElevator(elevatorManager: self, destinationFloor: destinationFloor, direction: direction)
        self.elevatorControllers[selectedElevator].moveToFloorAt(destinationFloor: destinationFloor)
    }
}

var elevatorManager1: ElevatorManager = ElevatorManager(controllerCount: 2, schedulingStrategyID: SchedulerStartegyID.RESPONSE_TIME)
var elevatorManager2: ElevatorManager = ElevatorManager(controllerCount: 2, schedulingStrategyID: SchedulerStartegyID.THROUGHPUT)

elevatorManager1.requestElevator(10, direction: Direction.UP)
elevatorManager2.requestElevator(8, direction: Direction.UP)

/*
 * 객체의 생성 코드를 사용하는 곳과 분리시켜서 객체 생성의 변환에 대비하는데 유용
 */