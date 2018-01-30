import Foundation
import XCTest
@testable import DVB

// swiftlint:disable identifier_name

class TripTests: XCTestCase {
    func testTripLocation() {
        let e = expectation(description: "Find a trip")

        let walpurgisstr = "33000029"
        let hbfnord = "33000032"

        Departure.monitor(stopWithId: walpurgisstr) { result in
            guard let departures = result.success else {
                XCTFail("Couldn't fetch departures")
                e.fulfill()
                return
            }

            let tripID = departures.departures[0].id

            TripStop.get(forTripID: tripID, stopID: hbfnord, atTime: Date()) { result in
                switch result {
                case .failure(let error):
                    XCTFail("Failed with error: \(error)")
                    e.fulfill()
                case .success(let response):
                    XCTAssertGreaterThan(response.stops.count, 0)
                    e.fulfill()
                }
            }
        }

        waitForExpectations(timeout: 5)
    }
}
