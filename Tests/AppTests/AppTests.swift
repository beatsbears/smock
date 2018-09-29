import App
import XCTest
import Codability

final class AppTests: XCTestCase {
    
    func testPayloadParse() throws {
        let rm = ResponseMapper()
        let testJSON: AnyCodable = ["test": 1]
        XCTAssert(rm.payloadType(payload: testJSON).rawValue == "JSON")
        
        let testText: AnyCodable = "test"
        XCTAssert(rm.payloadType(payload: testText).rawValue == "TEXT")
        
        let testNum: AnyCodable = 123
        XCTAssert(rm.payloadType(payload: testNum).rawValue == "NUM")
        
        let testBool: AnyCodable = false
        XCTAssert(rm.payloadType(payload: testBool).rawValue == "BOOL")
        
        let testArray: AnyCodable = ["1", "2"]
        XCTAssert(rm.payloadType(payload: testArray).rawValue == "JSON")
    }

    static let allTests = [
        ("testPayloadParse", testPayloadParse)
    ]
}
