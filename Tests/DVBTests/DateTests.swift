import Foundation
import XCTest
@testable import DVB

class DateTests: XCTestCase {
    func testDatestring() {
        let now = Date()
        guard let parsed = try? Date.value(from: now.datestring) else {
            XCTFail("Could not parse datestring")
            return
        }

        XCTAssertEqualWithAccuracy(now.timeIntervalSince1970, parsed.timeIntervalSince1970, accuracy: 1.0)
    }
}
