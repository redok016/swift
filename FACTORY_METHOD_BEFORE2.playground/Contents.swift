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
    
    func requestElevator(destinationFloor: Int, direction: Direction) {
        let elevatorScheduler: ElevatorScheduler
        let hour = NSCalendar.currentCalendar().component(.Hour, fromDate: NSDate())
        
        if hour < 12 {
            elevatorScheduler = ResponseTimeScheduler()
        } else {
            elevatorScheduler = ThroughputScheduler()
        }
        
        let selectedElevator: Int = elevatorScheduler.selectElevator(elevatorManager: self, destinationFloor: destinationFloor, direction: direction)
        self.elevatorControllers[selectedElevator].moveToFloorAt(destinationFloor: destinationFloor)
    }
}

/*
 * 스트래티지 패턴으로 동적으로 스케쥴러를 바꿀 수 있도록 수정했으나 엘리베이터 전략이 추가되거나 변경될 때 마다 requestElevator가 수정되어야 함
 * requestElevator의 역할은? 엘리베이터를 선택, 선택한 엘리베이터를 이동시키는 역할이다. 따라서 엘리베이터를 선택하는 전략의 변경이 있을 때마다 requestElevator메소드가 수정되는 것은 바람직하지 못하다.
 */
