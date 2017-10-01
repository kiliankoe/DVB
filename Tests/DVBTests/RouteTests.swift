import Foundation
import XCTest
@testable import DVB

class RouteTests: XCTestCase {
    func testRouteFromAlbertToHbf() {
        let e = expectation(description: "Find a route")

        let session = Session(cassetteName: #function)

        let date = Date(timeIntervalSince1970: 1490561146) // 2017-03-26 22:45:46

        let albertplatz = "33000013"
        let hauptbahnhof = "33000028"
        Route.find(fromWithID: albertplatz, toWithID: hauptbahnhof, time: date, session: session) { result in
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

    func testRouteFromPostplatzToPirnaischerPlatz() {
        let e = expectation(description: "Find a route")

        let session = Session(cassetteName: #function)
        session.beginRecording()

        let date = Date(timeIntervalSince1970: 1490561146) // 2017-03-26 22:45:46

        Route.find(from: "Postplatz", to: "Pirnaischer Platz", time: date, session: session) { result in
            session.endRecording()

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
