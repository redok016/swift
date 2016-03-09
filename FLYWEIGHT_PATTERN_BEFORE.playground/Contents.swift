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

class Spreadsheet {
    var grid = Dictionary<Coordinate, Cell>()
    
    init() {
        
        let letters: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        var stringIndex = letters.startIndex
        let rows = 50
        
        repeat {
            let colLetter = letters[stringIndex];
            stringIndex = stringIndex.successor();
            for rowIndex in 1 ... rows {
                let cell = Cell(col: colLetter, row: rowIndex, val: rowIndex)
                grid[cell.coordinate] = cell
            }
        } while (stringIndex != letters.endIndex)
    }
    
    func setValue(coord: Coordinate, value: Int) {
        grid[coord]?.value = value
    }
    
    var total:Int {
        return grid.values.reduce(0, combine: {total, cell in return total + cell.value});
    }
}
