import UIKit


// 프로토콜 사용 예시
protocol Music {
    func playPiano(title: String, time: Int)
    func sing(title: String)
    
    var name: String { get }
}

class Pianist: Music {
    func playPiano(title: String, time: Int) {
        print("\(name)은/는 \(title)을 \(time)동안 연주했다.")
    }
    
    func sing(title: String) {
        print("\(name)은/는 \(title)을 부른다.")
    }
    
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
}

let pianist = Pianist(name: "Eddy")
pianist.playPiano(title: "River Flows in you", time: 3)



// 클래스, 상속 예시 -> 불필요한 속성도 상속받을 수 있다는 문제점이 있다.

class A {
    var name: String = "에디"
}
let a = A()
a.name = "A"
print(a.name)

class B: A {
    var age: Int = 20
}
let b = B()
b.name = "B"
b.age = 25
print(b.name)
print(b.age)

class C: B {
    var location: String = "서울"
}
let c = C()
c.name = "C"
c.age = 30
c.location = "부산"
print(c.name)
print(c.age)
print(c.location)


//// Swift Class의 단일 상속 원칙
//
//struct TestClass {
//}
//
//struct TestStruct {
//}
//
//struct Test: TestStruct, TestClass {
//}




// Extension 프로토콜 테스트

protocol TestProtocol {
    func goToCompany()
}

extension TestProtocol {
    func goToCompany() { print("회사갈거야?") }
    func playGame() { print("게임하러 가자~") } // 확장 프로토콜 구현 함수
}
class TestClass: TestProtocol {
    func goToCompany() { print("출근") }
    func goToHome() { print("퇴근") }

    func playGame() { print("게임하기") }
}


struct TestStruct: TestProtocol {
    func goToCompany() { print("출근") }
    func goToHome() { print("퇴근") }

    func playGame() { print("게임하기") }
}


let testClass1: TestClass = TestClass()
testClass1.goToCompany()
testClass1.playGame()

let testClass2: TestProtocol = TestClass()
testClass1.goToCompany()
testClass1.playGame()

let testStruct1: TestStruct = TestStruct()
testStruct1.goToCompany()
testStruct1.playGame()

let testStruct2: TestProtocol = TestStruct()
testStruct2.goToCompany()
testStruct2.playGame()
