//: Playground - noun: a place where people can play

import UIKit

struct Appointment {
    var name: String
    var day: String
    var place: String
    
    func printDetails() {
        print("==NAME: \(self.name), DAY: \(self.day), PLACE: \(self.place)")
    }
}

var beerMeeting: Appointment = Appointment(name: "Bob", day: "Mon", place: "Joe's Bar")
var workMeeting: Appointment = beerMeeting
beerMeeting.printDetails()
workMeeting.printDetails()

workMeeting.name = "Jack"
beerMeeting.printDetails()
workMeeting.printDetails()


class Location : NSObject, NSCopying {
    var name: String
    var address: String
    
    init(name: String, address: String) {
        self.name = name
        self.address = address
    }
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        return Location(name: self.name, address:self.address)
    }
}

class Appointment2: NSObject, NSCopying {
    var name: String
    var day: String
    var place: Location
    
    init(name: String, day: String, place: Location) {
        self.name = name
        self.day = day
        self.place = place
    }
    
    func printDetails() {
        print("==NAME: \(self.name), DAY: \(self.day), PLACE: \(self.place.name) \(self.place.address)")
    }
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        return Appointment2(name: self.name, day:  self.day, place:  self.place.copy() as! Location)
    }
}

var beerMeeting2: Appointment2 = Appointment2(name: "Bob", day: "Mon", place: Location(name: "Joe's Bar", address: "123 Main st"))
var workMeeting2: Appointment2 = beerMeeting2.copy() as! Appointment2

beerMeeting2.printDetails()
workMeeting2.printDetails()

workMeeting2.name = "Jack"
workMeeting2.place.name = "Conference Rm 2"
workMeeting2.place.address = "Compay HQ"

beerMeeting2.printDetails()
workMeeting2.printDetails()


class Person: NSObject, NSCopying {
    var name: String
    var country: String
    
    init(name: String, country: String) {
        self.name = name
        self.country = country
        
    }
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        return Person(name: self.name, country: self.country);
    }
}

var people = [Person(name:"Joe", country:"France"),
    Person(name:"Bob", country:"USA")];
var otherpeople = people;

people[0].country = "UK";
print("Country: \(otherpeople[0].country)");


func deepCopy(data:[AnyObject]) -> [AnyObject] {
    return data.map({item -> AnyObject in
        if (item is NSCopying && item is NSObject) {
            return (item as! NSObject).copy()
        } else {
            return item
        }
    })
}

var people2 = [Person(name:"Joe", country:"France"),
    Person(name:"Bob", country:"USA")];
var otherpeople2 = deepCopy(people2) as! [Person];
people2[0].country = "UK";
print("Country: \(otherpeople2[0].country)");