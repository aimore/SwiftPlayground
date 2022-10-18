import Foundation

//MARK: classes

class Developer {
    //strong reference
    let name: String
    var language: Language?
    var languageNew: LanguageNew?
    
    init(name: String) {
        self.name = name
        print("\(name) is being initialized")
    }
    deinit {
        print("\(name) is being deinitialized")
    }
}

class Language {
    //strong references
    let tech: String
    var dev: Developer?
    
    init(tech: String) {
        self.tech = tech
        print("\(tech) is being initialized")
    }
    
    deinit {
        print("\(tech) is being deinitialized")
    }
}

//Resolving Strong Reference Cycles Between Class Instances
//weak references
class LanguageNew {
    //strong reference
    let tech: String
    //weak reference
    //Weak references must be typed as Optional
    // weak var dev: Developer - will show a compile error
    weak var dev: Developer?
    
    init(tech: String) {
        self.tech = tech
        print("\(tech) is being initialized")
    }
    
    deinit {
        print("\(tech) is being deinitialized")
    }
}

//Unowned References
class Car {
    let brand: String
    var modelNumber: ModelNumber?
    
    init(brand: String) {
        self.brand = brand
        print("Car \(brand) is being initialized")
    }
    
    deinit { print("Car \(brand) is being deinitialized") }
}


class ModelNumber {
    let number: UInt64
    //unowned reference
    //if not optional will need to store prop in init
    unowned var car: Car
    
    init(car: Car, number: UInt64) {
        self.number = number
        self.car = car
        print("ModelNumber #\(number) is being initialized")

    }
    
    deinit {
        print("ModelNumber #\(number) is being deinitialized")
    }
}

//Unowned Optional References
class Department {
    var name: String
    var courses: [Course]
    init(name: String) {
        self.name = name
        self.courses = []
        print("Department \(name) is being initialized")
    }
    
    deinit {
        print("Department \(name) is being deinitialized")
    }
}

class Course {
    var name: String
    unowned var department: Department
    unowned var nextCourse: Course?
    init(name: String, in department: Department) {
        self.name = name
        self.department = department
        self.nextCourse = nil
        print("Course \(String(describing: nextCourse?.name.description)) is being initialized")
    }
    
    deinit {
        print("Course \(String(describing: nextCourse?.name.description)) is being deinitialized")
    }
}

//Weak self closure
struct Post {
    let title: String
    var isPublished: Bool = false

    init(title: String) {
        self.title = title
        print("Post \(title) is being initialized")
    }
}

class Blogger {
    let name: String
    var blog: Blog?

    init(name: String) {
        self.name = name
    }

    deinit {
        print("Blogger \(name) is being deinitialized")
    }
}

class Blog {
    let name: String
    let url: URL
    weak var owner: Blogger?

    var publishedPosts: [Post] = []

    init(name: String, url: URL) {
        self.name = name
        self.url = url
        print("Blog \(name) is being initialized")
    }

    deinit {
        print("Blog \(name) is being deinitialized")
    }

    //Wrong usage of weak self
    func publishWeak(post: Post) {
        /// Faking a network request with this delay:
        //correct use of strong self reference
        //DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.publishedPosts.append(post)
            //If we would change the publish method to include a weak reference instead:
            print("Published post count is now: \(self?.publishedPosts.count)")
        }
    }
    
    //correct use of strong self reference
    func publish(post: Post) {
        /// Faking a network request with this delay:
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.publishedPosts.append(post)
            //If we would change the publish method to include a weak reference instead:
            print("Published post count is now: \(self.publishedPosts.count)")
        }
    }
}

//MARK: functions

public func createStrongRefence() {
    //Developer strong references with initial value as nil
    var reference1: Developer?
    var reference2: Developer?
    var reference3: Developer?
    
    //3 Developer objects will be initialized
    reference1 = Developer(name: "Dummy Dev")
    reference2 = reference1
    reference3 = reference1
    
    //deinit still won't be called as we still have a reference3
    reference1 = nil
    reference2 = nil
    
    //deinit will be called
    reference3 = nil
}

public func createStrongReferenceCycle() {
    var dev1: Developer?
    var tech1: Language?
    
    dev1 = Developer(name: "Dev 1")
    tech1 = Language(tech: "Swift")
    
    dev1!.language = tech1
    tech1!.dev = dev1
    
    //deinit is not called dev1 and tech1 are not deallocated
    dev1 = nil
    tech1 = nil
}

//Create weak reference of Developer in LanguageNew class
public func fixStrongReferenceCycle() {
    var dev1: Developer?
    var tech1: LanguageNew?
    
    dev1 = Developer(name: "Dev 1")
    tech1 = LanguageNew(tech: "Swift")
    
    dev1!.languageNew = tech1
    tech1!.dev = dev1
    
    // deinit is called dev1 and tech1 are deallocated
    dev1 = nil
    tech1 = nil
}

public func createUnownedReference() {
    var car1: Car?
    car1 = Car(brand: "Mercedes")
    car1!.modelNumber = ModelNumber(car: car1!, number: 123456)
    car1 = nil
}

public func createUnownedOptionalReference() {
    let department = Department(name: "Horticulture")

    let intro = Course(name: "Survey of Plants", in: department)
    let intermediate = Course(name: "Growing Common Herbs", in: department)
    let advanced = Course(name: "Caring for Tropical Plants", in: department)

    intro.nextCourse = intermediate
    intermediate.nextCourse = advanced
    department.courses = [intro, intermediate, advanced]
}

public func correctUsageOfStrongSelf() {
    var blog: Blog? = Blog(name: "Correct", url: URL(string: "www.blog.com")!)
    var blogger: Blogger? = Blogger(name: "Some Blogger")

    blog!.owner = blogger
    blogger!.blog = blog

    blog!.publish(post: Post(title: "Explaining correct usage of strong self"))
    blog = nil
    blogger = nil
}

public func wrongUsageOfWeakSelf() {
    var blog: Blog? = Blog(name: "Wrong", url: URL(string: "www.blog.com")!)
    var blogger: Blogger? = Blogger(name: "Some Blogger")

    blog!.owner = blogger
    blogger!.blog = blog

    blog!.publishWeak(post: Post(title: "Explaining wrong ussage of weak self"))
    blog = nil
    blogger = nil
}

