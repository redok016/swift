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

let ss1 = Spreadsheet();
ss1.setValue(Coordinate(col: "A", row: 1), value: 100);
ss1.setValue(Coordinate(col: "J", row: 20), value: 200);
print("SS1 Total: \(ss1.total)");

let ss2 = Spreadsheet();
ss2.setValue(Coordinate(col: "F", row: 10), value: 200);
ss2.setValue(Coordinate(col: "G", row: 23), value: 250);
print("SS2 Total: \(ss2.total)");

// flyweight 패턴이 해결해줄 수 있는 부분 중에 하나가 동일한 많은 수의 객체를 생성할 때 메모리, 생성에 드는 시간을 줄이는 것이다.
// 위 Spreadsheet 클래스를 생성할 때 마다 각 Spreadsheet 객체별로 위 컬렉션이 생성된다.


