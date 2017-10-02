import Foundation
import XCTest
@testable import DVB

class DateTests: XCTestCase {
    func testDatestring() {
        let now = Date()
        guard let parsed = Date(fromSAPPattern: now.sapPattern) else {
            XCTFail("Could not parse datestring")
            return
        }

        XCTAssertEqual(now.timeIntervalSince1970, parsed.timeIntervalSince1970, accuracy: 1.0)
    }
}
