import Foundation

/*
Why would you need dependency injection?
What problem is being solved with dependency injection?
It’s an important question to ask yourself before writing or picking your solution.
In my team, we recently revisited our approach to dependency injection as
it didn’t match our needs anymore now that our project became bigger.
We defined the following points to be solved based on the issues we experienced with our current solution:

 ◦ Mocking data for tests should be easy
 ◦ Readability should be maintained by staying close to Swift’s standard APIs
 ◦ Compile-time safety is prefered to prevent hidden crashes. If the app builds, we know all dependencies are configured correctly
 ◦ Big initialisers as a result of injecting dependencies should be avoided
 ◦ The AppDelegate should not be the place to define all shared instances
 ◦ No 3rd party dependency to prevent potential learning curves
 ◦ Force unwrapping shouldn’t be needed
 ◦ Defining standard dependency should be possible without exposing private/internal types within packages
 ◦ The solution should be defined in a package that can be shared across libraries for reusability
 
 You can inject dependencies in Swift with 2 approaches:

 Initializer injection: provide dependency via the initializer init()
 Property injection: provide dependency via a property (or setter)
 You can use either, but in a few use cases, one is better than the other.

 It’s recommended to use initializer injection for a dependency that doesn’t change during the lifetime of the dependant object
 When the dependency can change during the lifetime of the dependant object, or when it’s nil at initialization, it’s better to use property injection
 */


protocol NetworkService {
    func getData() -> String
}

final class RealDataManager: NetworkService {
    func getData() -> String {
        print("Requesting data.....")
        return "REAL DATA"
    }
}

//CONSTRUCTOR INJECTION
class DataManager {
    let dataService: NetworkService
    init(dataService: NetworkService) {
        self.dataService = dataService
    }
    
    func getData() -> String  {
        return dataService.getData()
    }
}

//CREATE TEST MOCK
class MockDataManager: NetworkService {
    func getData() -> String {
        print("Requesting mock data.....")
        return "MOCK DATA"
    }
}

// TEST CONSTRUCTOR INJECTION
public func testDataManagerGetData() {
    let mock = MockDataManager()
    let user = DataManager(dataService: mock)
    let data = user.getData()
    print(data)
    if(data == "MOCK DATA") {
        print("TEST PASSED")
    } else {
        print("TEST FAILED")
    }
}
