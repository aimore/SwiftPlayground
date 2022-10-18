import Foundation
import SwiftUI

public func generalQuestion1() {
    print("Select the invalid statement")
    //var name: String? = "Test"
    //var age: Int = nil
    //let score: Float = 89.5
    //var average: Double? = 74
}

//Optional Binding
public func generalQuestion2() {
    let possibleValue : String? = "Test"
    //    var possibleValue : String? = nil
    if let actualValue = possibleValue {
        print(actualValue)
    }
}

//Select the correct statement which can be used to identify if a given variable is an array of String elements.
public func generalQuestion3() {
    let arrayOfString = ["","",""]
    if arrayOfString is [String] {
        print("It is the same type!")
    }
}

//TUPLES
public func separateTuples() {
    let tupleA = ("Test", 123)
    var (a,b) = tupleA
    print(a)
    print(b)
}

//DICTIONARY
public func loopDictionary() {
    let dict = ["test":"1",
                "test1":"2",
                "test2":"3",
                "test3":"4",
                "test4":"5",
                "test5":"6"]
    
    for (keyString,valueString) in dict {
        print("\(keyString) --> \(valueString)")
    }
}

//foreach
//NOTE: that's available on swiftUI APIs
//A structure that computes views on demand from an underlying collection of identified data.
private struct NamedFont: Identifiable {
    let name: String
    let font: Int
    var id: String { name }
}


public func forEachLoop() {
    let namedFonts: [NamedFont] = [
        NamedFont(name: "Large Title",font: 11),
        NamedFont(name: "Title",font: 12),
        NamedFont(name: "Headline",font: 11),
        NamedFont(name: "Body",font: 13),
        NamedFont(name: "Caption", font: 14)
    ]
    
    ForEach(namedFonts) { namedFont in
        Text(namedFont.name)    }
}

// FOR-IN LOOP WITH COLLECTIONS
public func forLoopExample() {
    let cities = ["Amsterdam", "New York", "San Francisco"]
    for city in cities {
        print(city)
    }
}


//FOR-IN LOOP WITH DICTIONARIES
public func forLoopWithDicExample() {
    let ages = ["Antoine": 28, "Jaap": 2, "Jack": 72]
    for (name, age) in ages {
        print("\(name) is \(age) years old")
    }
}

//COMBINING A FOR LOOP WITH RANGES
public func forLoopWithRanges() {
    for index in (0...3).reversed() {
        print("\(index)..")
    }
}

//While loops
public func whileloop() {
    let maxTries = 6
    var tries = 0
    while tries < maxTries {
        tries += 1
        print("Tries value = \(tries)")
    }
}
