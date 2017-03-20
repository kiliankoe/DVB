import Foundation
import XCTest
@testable import DVB

class RouteTests: XCTestCase {
    func testFromAlbertToHbf() {
        let e = expectation(description: "Find a route")

        Route.find(fromWithID: "33000013", toWithID: "33000028") { result in
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

    func testFromPostToPirnaischer() {
        let e = expectation(description: "Find a route")

        Route.find(from: "Postplatz", to: "Pirnaischer Platz") { result in
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
