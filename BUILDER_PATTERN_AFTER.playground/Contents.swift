//: Playground - noun: a place where people can play

import UIKit

enum Burgers {
    case STANDARD; case BIGBURGER; case SUPERVEGGIE;
}

class Burger {
    let customerName:String; let veggieProduct:Bool; let patties:Int;
    let pickles:Bool;
    let mayo:Bool;
    let ketchup:Bool;
    let lettuce:Bool;
    let cook:Cooked;
    let bacon:Bool;
    enum Cooked : String {
        case RARE = "Rare";
        case NORMAL = "Normal";
        case WELLDONE = "Well Done";
    }
    init(name:String, veggie:Bool, patties:Int, pickles:Bool, mayo:Bool,
        ketchup:Bool, lettuce:Bool, cook:Cooked, bacon: Bool) {
            self.customerName = name;
            self.veggieProduct = veggie;
            self.patties = patties;
            self.pickles = pickles;
            self.mayo = mayo;
            self.ketchup = ketchup;
            self.lettuce = lettuce;
            self.cook = cook;
            self.bacon = bacon;
    }
    func printDescription() {
        print("Name \(self.customerName)");
        print("Veggie: \(self.veggieProduct)");
        print("Patties: \(self.patties)");
        print("Pickles: \(self.pickles)");
        print("Mayo: \(self.mayo)");
        print("Ketchup: \(self.ketchup)");
        print("Lettuce: \(self.lettuce)");
        print("Cook: \(self.cook.rawValue)");
        print("Bacon: \(self.bacon)")
    }
}

class BurgerBuilder {
    private var veggie  = false;
    private var pickles = false;
    private var mayo    = true;
    private var ketchup = true;
    private var lettuce = true;
    private var cooked  = Burger.Cooked.NORMAL;
    private var patties = 2;
    private var bacon   = true;
    private init() {
        // do nothing
    }
    func setVeggie(choice: Bool) {
        self.veggie = choice;
        if (choice) {
            self.bacon = false;
        }
    }
    func setPickles(choice: Bool) { self.pickles = choice; }
    func setMayo(choice: Bool)    { self.mayo    = choice; }
    func setKetchup(choice: Bool) { self.ketchup = choice; }
    func setLettuce(choice: Bool) { self.lettuce = choice; }
    func setCooked(choice: Burger.Cooked) { self.cooked = choice; }
    func addPatty(choice: Bool)   { self.patties = choice ? 3 : 2; }
    func setBacon(choice: Bool)   { self.bacon   = choice; }
    func buildObject(name: String) -> Burger {
        return Burger(name: name, veggie: veggie, patties: patties,
            pickles: pickles, mayo: mayo, ketchup: ketchup,
            lettuce: lettuce, cook: cooked, bacon: bacon);
    }
    class func getBuilder(burgerType:Burgers) -> BurgerBuilder {
        var builder:BurgerBuilder;
        switch (burgerType) {
        case .BIGBURGER: builder   = BigBurgerBuilder();
        case .SUPERVEGGIE: builder = SuperVeggieBurgerBuilder();
        case .STANDARD: builder    = BurgerBuilder();
        }
        return builder;
    }
}

class BigBurgerBuilder : BurgerBuilder {
    private override init() {
        super.init();
        self.patties = 4;
        self.bacon = false;
    }
    override func addPatty(choice: Bool) {
        fatalError("Cannot add patty to Big Burger");
    }
}

class SuperVeggieBurgerBuilder : BurgerBuilder {
    private override init() {
        super.init();
        self.veggie = true;
        self.bacon = false;
    }
    override func setVeggie(choice: Bool) {
        // do nothing - always veggie
    }
    override func setBacon(choice: Bool) {
        fatalError("Cannot add bacon to this burger");
    }
}


// Step 1 - Ask for name
let name = "Joe";
// Step 2 - Select a Product
let builder = BurgerBuilder.getBuilder(Burgers.BIGBURGER);
// Step 3 - Customize burger?
builder.setMayo(false);
builder.setCooked(Burger.Cooked.WELLDONE);
let order = builder.buildObject(name);
order.printDescription();


