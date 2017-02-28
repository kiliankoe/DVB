import Foundation
import XCTest
@testable import DVB

class TripTests: XCTestCase {
    func testFromAlbertToHbf() {
        let e = expectation(description: "Find a route")

        Trip.find(originId: "33000013", destinationId: "33000028") { result in
            switch result {
            case .failure(let error):
                XCTFail("Failed with error: \(error)")
            case .success(let response):
                guard response.routes.count > 0 else {
                    XCTFail("Found no routes")
                    return
                }
                e.fulfill()
            }
        }

        waitForExpectations(timeout: 5)
    }
}
