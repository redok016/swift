//: Playground - noun: a place where people can play

import UIKit

struct Employee {
    var name: String
    var title: String
}

protocol EmployeeDataSource {
    var employees: [Employee] { get }
    func searchByName(name: String) -> [Employee]
    func searchByTitle(title: String) -> [Employee]
}


class DataSourceBase : EmployeeDataSource {
    var employees = [Employee]();
    func searchByName(name: String) -> [Employee] {
        return search({e -> Bool in
            return e.name.rangeOfString(name) != nil
        })
    }
    func searchByTitle(title: String) -> [Employee] {
        return search({e -> Bool in
            return e.title.rangeOfString(title) != nil
        })
    }
    private func search(selector:(Employee -> Bool)) -> [Employee] {
        var results = [Employee]()
        for e in employees {
            if (selector(e)) {
                results.append(e)
            } }
        return results;
    }
}
class SalesDataSource : DataSourceBase {
    override init() {
        super.init()
        employees.append(Employee(name: "Alice", title: "VP of Sales"))
        employees.append(Employee(name: "Bob", title: "Account Exec"))
    }
}
class DevelopmentDataSource : DataSourceBase {
    override init() {
        super.init()
        employees.append(Employee(name: "Joe", title: "VP of Development"))
        employees.append(Employee(name: "Pepe", title: "Developer"))
    }
}

class SearchTool {
    enum SearchType {
        case NAME; case TITLE
    }
    private let sources:[EmployeeDataSource]
    init(dataSources: EmployeeDataSource...) {
        self.sources = dataSources
    }
    var employees:[Employee] {
        var results = [Employee]()
        for source in sources {
            results += source.employees
        }
        return results
    }
    func search(text:String, type:SearchType) -> [Employee] {
        var results = [Employee]()
        for source in sources {
            results += type == SearchType.NAME ? source.searchByName(text)
                : source.searchByTitle(text)
        }
        return results
    }
}

let search = SearchTool(dataSources: SalesDataSource(), DevelopmentDataSource());
print("--List--")
for e in search.employees {
    print("Name: \(e.name)")
}
print("--Search--")
for e in search.search("VP", type: SearchTool.SearchType.TITLE) {
    print("Name: \(e.name), Title: \(e.title)")
}
