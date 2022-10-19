import Foundation

//MARK: ARC

// Create multiple strong references of 1 class
//createStrongRefence()

//Strong Reference Cycles Between Class Instances
//createStrongReferenceCycle()

//Resolving Strong Reference Cycles Between Class Instances
//fixStrongReferenceCycle()

//Unowned References
//createUnownedReference()

//Unowned Optional References
//createUnownedOptionalReference()

//Wrong usage of weak self
//wrongUsageOfWeakSelf()

//correct use of strong self reference in closure
//correctUsageOfStrongSelf()

//MARK: GENERAL SWIFT QUESTIONS

//What is the value of number  after executing the following code?
//public extension Int {
//    mutating func square() {
//        self = self * self
//    }
//}
//var number = 2
//number.square()

//What is the Swift language concept demonstrated in the following code?
//generalQuestion2()

//Checking Type
//generalQuestion3()

// Access Modifier

//MARK: TUPLES & DICTIONARIES

//Access key and value from a dictionary
//loopDictionary()

//Access tuple separately
//separateTuples()

//MARK: LOOPS

//Foreach example
//forEachLoop()

//For loop example
//forLoopExample()

//For loop with ranges example
//forLoopWithRanges()

//While example
//whileloop()

//MARK: DEPENDENCY INJECTION

//constructor injection
//testDataManagerGetData()

//propert injection
//testDataManager2GetData()

//MARK: SINGLETON PATTERN
//globalSingleton()

//Refactoring singleton for Unit test
//testSingletonMock()

//MARK: ACCESS LEVELS
//Open
//class Test : OpenClass {
//    override init() {}
//    override func testFunc() {
//        print("No value")
//    }
//}
//let b = OpenClass()
//b.testFunc()
//let a = Test()
//a.testFunc()

//PUBLIC
// Public — This is the same as open, the only difference is you can’t subclass or override outside the module(target).
//Cannot inherit from non-open class 'PublicClass' outside of its defining module
//class Test2 : PublicClass {
//}
//testPublic()

//PRIVATE and INTERNAL
//let a = PrivateTest()
//'user' is inaccessible due to 'private' protection level
//a.user

// File-private
/*
 File-private - This is the same as private, the only difference is it allows access in a subclass with in the same file.
 */
// it allows access in a subclass with in the same file.
//filePrivateTest()
//let fp = TestFilePrivate()
//'user' is inaccessible due to 'fileprivate' protection level
//fp.user
