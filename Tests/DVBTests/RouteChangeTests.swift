import Foundation
import XCTest
@testable import DVB

class RouteChangeTests: XCTestCase {

    func testGetRouteChanges() {
        let e = expectation(description: "Get route changes")

        RouteChange.get { result in
            switch result {
            case let .failure(error):
                XCTFail("Failed with error: \(error)")
            case let .success(response):
                XCTAssertGreaterThan(response.lines.count, 0)
                XCTAssertGreaterThan(response.changes.count, 0)
                e.fulfill()
            }
        }

        waitForExpectations(timeout: 5)
    }
}
