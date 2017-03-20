import Foundation
import XCTest
@testable import DVB

class TripTests: XCTestCase {
    func test3FromAlpAtHbf() {
        let e = expectation(description: "Find a trip")

        // Kinda wanna keep this test readable, so let's do it synchronously.
        let semaphore = DispatchSemaphore(value: 0)
        var tripId = ""

        let albertplatz = "33000013"
        Departure.monitor(stopWithId: albertplatz) { result in
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

        let hauptbahnhof = "33000028"
        TripStop.get(forTripID: tripId, stopID: hauptbahnhof, atTime: Date()) { result in
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
