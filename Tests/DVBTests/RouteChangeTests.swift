import Foundation
import XCTest
@testable import DVB

class RouteChangeTests: XCTestCase {

    func testGetRouteChanges() {
        let e = expectation(description: "Get route changes")

        RouteChange.get { result in
            switch result {
            case .failure(let error):
                XCTFail("Failed with error: \(error.localizedDescription)")
            case .success(let response):
                guard response.lines.count > 0,
                    response.changes.count > 0 else {
                        XCTFail("Response contains no lines or changes")
                        return
                }

                e.fulfill()
            }
        }

        waitForExpectations(timeout: 5)
    }
}
