import XCTest
@testable import DVB

class DVBTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(DVB().text, "Hello, World!")
    }


    static var allTests : [(String, (DVBTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
