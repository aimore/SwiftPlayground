import Foundation

/*
 Access control restricts access to parts of your code from code in other source files and modules.
 This feature enables you to hide the implementation details of your code, and to specify a preferred interface
 through which that code can be accessed and used.
 */
 

//Open
/*
 Open — This is where you can access all data members and member functions within the same module(target) and outside of it.
 You can subclass or override outside the module(target).
 */

open class OpenClass {
    
    //needs to be public to be instatiate in SwiftPlayground
    public init() { }
    
    let value1 : String = "Value is "
    let value2 : Int = 34
    //If use  public func testFunc() :  error: overriding non-open instance method outside of its defining module
    open func testFunc() {
        print("\(value1)\(value2)")
    }
}

/*
 Public — This is the same as open, the only difference is you can’t subclass or override outside the module(target).
 */
public class PublicClass {
    let a = "Test"
    
    func testFunc() {
        print(a)
    }
}

//If I remove the public I won't be able to access it from SwiftPlayground file
public func testPublic() {
    let a = OpenClass()
    a.testFunc()
}

//Internal — This is the default access level in Swift, it allows all data members and member functions to be accessed within the same module(target) only and restrict access outside the module(target).
// init() {} =  internal init() { }
/*
 Private — This is where you can access data members and function within its enclosing declaration as well as an extension within the same file. It does not allow access in a subclass with in the same file or in another file.
 */

public class PrivateTest {
    //'PrivateTest' initializer is inaccessible due to 'internal' protection level
    // init() {}
//    public init() {}
    private let user = "Private USer"
    
}

// File-private
/*
 File-private - This is the same as private, the only difference is it allows access in a subclass with in the same file.
 */

public class TestFilePrivate {
    public init() { }
    fileprivate var user : String = "File private user"
}


public func filePrivateTest() {
    let a = TestFilePrivate()
    //same file access
    print(a.user)
}

