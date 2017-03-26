import Foundation
import XCTest
import DVR
@testable import DVB

class RouteChangeTests: XCTestCase {

    func testGetRouteChanges() {
        let e = expectation(description: "Get route changes")

        let session = Session(cassetteName: #function)

        RouteChange.get(session: session) { result in
            switch result {
            case let .failure(error):
                XCTFail("Failed with error: \(error)")
            case let .success(response):
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
