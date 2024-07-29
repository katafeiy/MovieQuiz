import XCTest

@testable import MovieQuiz

class ArrayTest: XCTestCase {
    
    func testGetValueInRun() throws {
        
        let array = [1, 2, 3, 4, 5]
        
        let value = array[safe: 2]
        
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 3)
        
    }
    
    func testGetValueOutOfRange() throws {
        
        let array = [1, 2, 3, 4, 5]
        
        let value = array[safe: 20]
        
        XCTAssertNil(value)
        
    }
    
}
