import Foundation
import XCTest
@testable import DVB

class DepartureTests: XCTestCase {
    func testETA() {
        let now = Date()
        let in5 = now.addingTimeInterval(5 * 60 + 1) // a second extra
        let platform = Platform(name: "3", type: "Platform")
        let diva = Diva(number: "11003", network: "voe")

        let dep1 = Departure(id: "123", line: "3", direction: "Wilder Mann", platform: platform, mode: .Tram, realTime: in5, scheduledTime: now, state: .delayed, routeChanges: nil, diva: diva)
        XCTAssertEqual(dep1.scheduledEta, 0)
        XCTAssertEqual(dep1.actualEta, 5)

        let dep2 = Departure(id: "123", line: "3", direction: "Wilder Mann", platform: platform, mode: .Tram, realTime: nil, scheduledTime: now, state: .delayed, routeChanges: nil, diva: diva)
        XCTAssertEqual(dep2.actualEta, nil)
    }

    func testFancyETA() {
        let now = Date()
        let in5 = now.addingTimeInterval(5 * 60 + 1)

        let dep1 = Departure(id: "", line: "", direction: "", platform: Platform(name: "", type: ""), mode: .Tram, realTime: nil, scheduledTime: in5, state: .onTime, routeChanges: nil, diva: nil)
        XCTAssertEqual(dep1.fancyEta, "5")

        let dep2 = Departure(id: "", line: "", direction: "", platform: Platform(name: "", type: ""), mode: .Tram, realTime: in5, scheduledTime: now, state: .onTime, routeChanges: nil, diva: nil)
        XCTAssertEqual(dep2.fancyEta, "0+5")

        let dep3 = Departure(id: "", line: "", direction: "", platform: Platform(name: "", type: ""), mode: .Tram, realTime: now, scheduledTime: in5, state: .onTime, routeChanges: nil, diva: nil)
        XCTAssertEqual(dep3.fancyEta, "5-5")

        let dep4 = Departure(id: "", line: "", direction: "", platform: Platform(name: "", type: ""), mode: .Tram, realTime: in5, scheduledTime: in5, state: .onTime, routeChanges: nil, diva: nil)
        XCTAssertEqual(dep4.fancyEta, "5")
    }

    func testEquality() {
        let dep1 = Departure(id: "123", line: "", direction: "", platform: Platform(name: "", type: ""), mode: .Tram, realTime: nil, scheduledTime: Date(), state: .onTime, routeChanges: nil, diva: nil)
        let dep2 = Departure(id: "123", line: "", direction: "", platform: Platform(name: "", type: ""), mode: .Tram, realTime: nil, scheduledTime: Date(), state: .onTime, routeChanges: nil, diva: nil)

        XCTAssert(dep1 == dep2)
    }

    func testDescription() {
        let dep = Departure(id: "123", line: "85", direction: "Löbtau", platform: Platform(name: "", type: ""), mode: .Tram, realTime: nil, scheduledTime: Date(), state: .onTime, routeChanges: nil, diva: nil)

        XCTAssertEqual(dep.description, "85 Löbtau departing in 0 minutes.")
    }

    func testMonitor() {
        let e = expectation(description: "Find correct departures")

        Departure.monitor(stopWithId: "33000037") { result in
            switch result {
            case .failure(let error):
                XCTFail("Failed with error: \(error)")
            case .success(let response):
                guard response.departures.count > 0 else {
                    XCTFail("Response contains no departures")
                    return
                }
                e.fulfill()
            }
        }

        waitForExpectations(timeout: 5)
    }

    func testMonitorWithName() {
        let e = expectation(description: "Find correct departures")

        Departure.monitor(stopWithName: "Hauptbahnhof") { result in
            switch result {
            case .failure(let error):
                XCTFail("Failed with error: \(error)")
            case .success(let response):
                guard response.departures.count > 0 else {
                    XCTFail("Response contains no departures")
                    return
                }
                e.fulfill()
            }
        }

        waitForExpectations(timeout: 5)
    }

    func testNonExistantStopId() {
        let e = expectation(description: "Get ServiceError")

        Departure.monitor(stopWithId: "1337") { result in
            switch result {
            case .failure(let error):
                guard let error = error as? DVBError,
                    case let .request(status, message) = error else {
                        XCTFail("Error is not of correct type with metadata.")
                        return
                }
                XCTAssertEqual(status, "ServiceError")
                XCTAssertEqual(message, "stop invalid")
                e.fulfill()
            case .success(_):
                XCTFail("Shouldn't get successful response for non-existant stop ID.")
            }
        }

        waitForExpectations(timeout: 5)
    }
}
