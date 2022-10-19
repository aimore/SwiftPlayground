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

//MARK: CONSTRUCTOR INJECTION

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


//MARK: PROPERTY INJECTION

class DataManager2 {
    var dataService: NetworkService = RealDataManager()
    func getData() -> String {
        print("Requesting mock data.....")
        return "DATA"
    }
}


// TEST PROPERTY INJECTION
public func testDataManager2GetData() {
    let manager = DataManager2()
    manager.dataService = MockDataManager()
    let mockData = manager.dataService.getData()
    if(mockData == "MOCK DATA") {
        print("TEST PASSED")
    } else {
        print("TEST FAILED")
    }
}


//MARK: SINGLETON
//The singleton pattern guarantees that only one instance of a class is instantiated.
//Static Property and Private Initializer
class NetworkServiceSingleton {
    
    static let shared = NetworkServiceSingleton()
    
    //DON'T FORGET THE PRIVATE INIT!
    //This makes sure your singletons are truly unique and prevents outside objects from creating their own instances of your class through virtue of access control.
    //Since all objects come with a default public initializer in Swift, you need to override your init and make it private
    private init(){}
    
    func getData() -> String {
        print("Requesting data.....")
        return "REAL DATA"
    }
}


class DataManagerUsingSingleton {
    func getData() -> String {
        let data = NetworkServiceSingleton.shared.getData()
        print(data)
        return data
    }
}

public func globalSingleton() {
    let data = NetworkServiceSingleton.shared.getData()
    print(data)
}

//How to test it? It will need a bit of refactoring...

//1. Abstract into a protocol
protocol NetworkEngine {
    func performRequest() -> String
}

extension NetworkServiceSingleton: NetworkEngine {
    func performRequest() -> String {
        return NetworkServiceSingleton.shared.getData()
    }
}

// Use the protocol with the singleton as the default
class DataLoader {

    private let engine: NetworkEngine

    init(engine: NetworkEngine = NetworkServiceSingleton.shared) {
        self.engine = engine
    }

    func load() -> String {
        return engine.performRequest()
    }
}

//Test Singleton using Mock
public func testSingletonMock() {
    //3. Mock the protocol in your tests
    class NetworkEngineMock: NetworkEngine {
        func performRequest() -> String {
            print("Requesting mock data.....")
            return "MOCK DATA"
        }
        
    }

    let engine = NetworkEngineMock()
    let loader = DataLoader(engine: engine)
    
    let test = loader.load()
    print(test)
}

//MARK: DI Container

protocol DIContainerProtocol {
  func register<Service>(type: Service.Type, service: Any)
  func resolve<Service>(type: Service.Type) -> Service?
}

final class DIContainer: DIContainerProtocol {

  static let shared = DIContainer()
  private init() {}

  var services: [String: Any] = [:]

  func register<Service>(type: Service.Type, service: Any) {
      services["\(type)"] = service
      print(service)
  }

  func resolve<Service>(type: Service.Type) -> Service? {
      let service = services["\(type)"] as? Service
      print(service as Any)
      return service
  }
    
}

// EXAMPLE
protocol UserServiceProtocol {
    func fetchUsers()
}

protocol PaymentServiceProtocol {
    func fetchPayments()
}

class UserService: UserServiceProtocol {
    func fetchUsers() {
        print("Users fetching...")
    }
}

class PaymentService: PaymentServiceProtocol {
    func fetchPayments() {
        print("Payments fetching...")
    }
}

//Not using DI Container
class ViewModel1 {

    private let userService: UserServiceProtocol
    private let paymentService: PaymentServiceProtocol

    init(userService: UserServiceProtocol, paymentService: PaymentServiceProtocol) {
        self.userService = userService
        self.paymentService = paymentService
    }
    
    func fetchUsers() {
        userService.fetchUsers()
    }
    
    func fetchPayments() {
        paymentService.fetchPayments()
    }

}

//using DI Container
class ViewModel2 {

    private let userService: UserServiceProtocol?
    private let paymentService: PaymentServiceProtocol?
    
    init(userService: UserServiceProtocol = DIContainer.shared.resolve(type: UserServiceProtocol.self)!,
         paymentService: PaymentServiceProtocol = DIContainer.shared.resolve(type: PaymentService.self)!) {
        self.userService = userService
        self.paymentService = paymentService
    }


    func fetchUsers() {
        userService?.fetchUsers()
    }
    
    func fetchPayments() {
        paymentService?.fetchPayments()
    }

}

public func registerObjects() {
    let container = DIContainer.shared
    container.register(type: UserServiceProtocol.self, service: UserService())
}

public func testDiContainer() {
    registerObjects()
    let a = ViewModel2()
    a.fetchUsers()
    a.fetchPayments()
}
