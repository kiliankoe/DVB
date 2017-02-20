import Foundation
import XCTest
import DVB

class RouteChangesTests: XCTestCase {
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

#if os(Linux)
    extension RouteChangesTests {
        static var allTests: [(String, (RouteChangesTests) -> () throws -> Void)] {
            return [
                ("testGetRouteChanges", testGetRouteChanges),
            ]
        }
    }
#endif
