import Foundation
import XCTest
@testable import DVB

class StopTests: XCTestCase {
    func testStopDescription() {
        let stop = Stop(id: "33000742", name: "Helmholtzstraße", region: nil, location: nil)
        XCTAssertEqual(stop.description, "Helmholtzstraße")
    }

    func testStopFromString() {
        let string = "33000742|||Helmholtzstraße|5655904|4621157|0||"
        let stop = Stop(string: string)!

        XCTAssertEqual(stop.id, "33000742")
        XCTAssertEqual(stop.name, "Helmholtzstraße")
        XCTAssertEqual(stop.region, nil)
    }
}

#if os(Linux)
extension StopTests {
    static var allTests: [(String, (StopTests) -> () throws -> Void)] {
        return [
            ("testStopDescription", testStopDescription),
            ("testStopFromString", testStopFromString),
        ]
    }
}
#endif
