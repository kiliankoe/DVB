import Foundation
import XCTest
@testable import DVB

class TripTests: XCTestCase {
    func test3AtHbf() {
        let e = expectation(description: "Find a trip")

        // Kinda wanna keep this test readable, so let's do it synchronously.
        let semaphore = DispatchSemaphore(value: 0)
        var tripId = ""

        Departure.monitor(stopWithId: "33000013") { result in
            switch result {
            case .failure(let error):
                XCTFail("Failed with error: \(error)")
            case .success(let response):
                guard let coschuetz3 = response.departures.filter({ $0.line == "3" && $0.direction == "Coschütz" }).first else {
                    XCTFail("Couldn't find a fitting departure at this time. Live API tests stink.")
                    return
                }
                tripId = coschuetz3.id
                semaphore.signal()
            }
        }

        semaphore.wait()

        TripStop.get(forTripID: tripId, stopID: "33000264", atTime: Date()) { result in
            switch result {
            case .failure(let error):
                XCTFail("Failed with error: \(error)")
            case .success(let response):
                guard response.stops.count > 0 else {
                    XCTFail("Found no trip stops")
                    return
                }
                e.fulfill()
            }
        }

        waitForExpectations(timeout: 10)
    }
}
