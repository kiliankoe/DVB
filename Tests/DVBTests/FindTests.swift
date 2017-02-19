import Foundation
import XCTest
import DVB

class FindTests: XCTestCase {
    func testFindHelmholtzQuery() {
        let e = expectation(description: "Find correct stop")

        Stop.find(query: "Helmholtz") { result in
            switch result {
            case .failure(let e):
                XCTFail("Failed with error: \(e.localizedDescription)")
            case .success(let response):
                guard let helmholtz = response.stops.first else {
                    XCTFail("Response contains no stops")
                    return
                }
                XCTAssertEqual(helmholtz.name, "Helmholtzstraße")
                e.fulfill()
            }
        }

        waitForExpectations(timeout: 5)
    }

    // TODO: Test findNear()
}

#if os(Linux)
    extension FindTests {
        static var allTests: [(String, (FindTests) -> () throws -> Void)] {
            return [
                ("testFindHelmholtzQuery", testFindHelmholtzQuery),
            ]
        }
    }
#endif
