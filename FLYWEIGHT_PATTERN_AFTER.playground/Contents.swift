//: Playground - noun: a place where people can play

import UIKit


func == (lhs: Coordinate, rhs: Coordinate) -> Bool {
    return lhs.col == rhs.col && lhs.row == rhs.row
}

class Coordinate: Hashable, CustomStringConvertible {
    let col: Character
    let row: Int
    
    init(col: Character, row: Int) {
        self.col = col
        self.row = row
    }
    
    var hashValue: Int {
        return description.hashValue
    }
    
    var description: String {
        return "\(col)\(row)"
    }
}

class Cell {
    var coordinate: Coordinate
    var value: Int
    
    init(col: Character, row: Int, val: Int) {
        self.coordinate = Coordinate(col: col, row: row)
        self.value = val
    }
}


protocol Flyweight {
    subscript(index: Coordinate) -> Int? { get set }
    var total: Int { get }
    var count: Int { get }
}

class FlyweightImpl: Flyweight {
    private let extrinsicData:[ Coordinate: Cell]
    private var instrinsicData: [ Coordinate: Cell]
    private let queue: dispatch_queue_t
    
    private init(extrinsic: [Coordinate: Cell]) {
        self.extrinsicData = extrinsic
        self.instrinsicData = Dictionary<Coordinate, Cell>()
        self.queue = dispatch_queue_create("dataQ", DISPATCH_QUEUE_CONCURRENT)
    }
    
    subscript(key: Coordinate) -> Int? {
        get {
            var result:Int?
            dispatch_sync(self.queue, { () -> Void in
                if let cell = self.instrinsicData[key] {
                    result = cell.value
                } else {
                    result = self.extrinsicData[key]?.value
                }
            })
            return result
        }
        set (newValue) {
            if (newValue != nil) {
                dispatch_barrier_sync(self.queue, { () -> Void in
                    self.instrinsicData[key] = Cell(col: key.col, row: key.row, val: newValue!)
                })
            }
        }
    }
    
    var total: Int {
        var result = 0;
        dispatch_sync(self.queue, {() in
            result = self.extrinsicData.values.reduce(0, combine: {total, cell in
                if let intrinsicCell = self.instrinsicData[cell.coordinate] {
                    return total + intrinsicCell.value
                } else {
                    return total + cell.value
                }
            })
        })
        return result
    }
    
    var count:Int {
        var result = 0
        dispatch_sync(self.queue, {() in
            result = self.instrinsicData.count
        })
        return result
    }
}
