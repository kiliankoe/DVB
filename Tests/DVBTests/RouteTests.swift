import Foundation
import XCTest
@testable import DVB

// swiftlint:disable identifier_name

class RouteTests: XCTestCase {
    func testRouteFromAlbertToHbf() {
        let e = expectation(description: "Find a route")

        let albertplatz = "33000013"
        let hauptbahnhof = "33000028"
        Route.find(fromWithID: albertplatz, toWithID: hauptbahnhof, time: Date()) { result in
            switch result {
            case .failure(let error):
                XCTFail("Failed with error: \(error)")
            case .success(let response):
                XCTAssertGreaterThan(response.routes.count, 0)
                e.fulfill()
            }
        }

        waitForExpectations(timeout: 5)
    }

    func testRouteFromPostplatzToPirnaischerPlatz() {
        let e = expectation(description: "Find a route")

        Route.find(from: "Postplatz", to: "Pirnaischer Platz", time: Date()) { result in
            switch result {
            case .failure(let error):
                XCTFail("Failed with error: \(error)")
            case .success(let response):
                XCTAssertGreaterThan(response.routes.count, 0)
                e.fulfill()
            }
        }

        waitForExpectations(timeout: 5)
    }
}
