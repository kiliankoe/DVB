import Foundation
import XCTest
import DVB

class DVBTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        //// XCTAssertEqual(DVB().text, "Hello, World!")
    }
}

#if os(Linux)
extension DVBTests {
    static var allTests : [(String, (DVBTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
#endif
