import Foundation
import XCTest
import DVB

class MonitorTests: XCTestCase {
    func testPostplatzDepartures() {
        let e = expectation(description: "Find correct departures")

        Departure.monitor(id: "33000037") { result in
            switch result {
            case .failure(let e):
                XCTFail("Failed with error: \(e.localizedDescription)")
            case .success(let response):
                guard response.departures.count > 0 else {
                    XCTFail("Response contains no departures")
                    return
                }
                e.fulfill()
            }
        }

        waitForExpectations(timeout: 5)
    }
}

#if os(Linux)
    extension MonitorTests {
        static var allTests: [(String, (MonitorTests) -> () throws -> Void)] {
            return [
                ("testFindHelmholtzQuery", testFindHelmholtzQuery),
            ]
        }
    }
#endif
