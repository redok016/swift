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

class ThroughputScheduler {
    func selectElevator(elevatorManager manager: ElevatorManager,
                        destinationFloor floor: Int,
                        direction dir: Direction) -> Int {
        return 0
    }
}

class ElevatorManager {
    
    var elevatorControllers: [ElevatorController]
    var elevatorScheduler: ThroughputScheduler
    
    init(controllerCount: Int) {
        self.elevatorControllers = [ElevatorController]()
        for (var index: Int = 0; index < controllerCount; index++) {
            let elevatorController: ElevatorController = ElevatorController(id: index)
            self.elevatorControllers.append(elevatorController)
        }
        self.elevatorScheduler = ThroughputScheduler()
    }
    
    func requestElevator(destinationFloor: Int, direction: Direction) {
        let selectedElevator: Int = self.elevatorScheduler.selectElevator(elevatorManager: self, destinationFloor: destinationFloor, direction: direction)
        self.elevatorControllers[selectedElevator].moveToFloorAt(destinationFloor: destinationFloor)
    }
}

/*
 * ElevatorManager 클래스가 ThroughputScheduler라는 구상 클래스를 사용하는데 만약 다른 스케쥴링 클래스가 필요하다면?
 * 동적으로 스케쥴링 전략을 변경해야 한다면?
*/