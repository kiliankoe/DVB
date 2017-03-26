import Foundation
import XCTest
import DVR
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

    func testDepartureMonitorAtPostplatz() {
        let e = expectation(description: "Find correct departures")

        let session = Session(cassetteName: #function)

        let postplatz = "33000037"
        let date = Date(timeIntervalSince1970: 1490480797) // 2017-03-25 23:26:37
        Departure.monitor(stopWithId: postplatz, date: date, session: session) { result in
            switch result {
            case let .failure(error):
                XCTFail("Failed with error: \(error)")
            case let .success(response):
                guard response.departures.count > 0 else {
                    XCTFail("Response contains no departures")
                    return
                }
                e.fulfill()
            }
        }

        waitForExpectations(timeout: 5)
    }

    func testDepartureMonitorAtHauptbahnhofWithName() {
        let e = expectation(description: "Find correct departures")

        let session = Session(cassetteName: #function)

        session.beginRecording()

        let date = Date(timeIntervalSince1970: 1490480797) // 2017-03-25 23:26:37
        Departure.monitor(stopWithName: "Hauptbahnhof", date: date, session: session) { result in
            session.endRecording()

            switch result {
            case let .failure(error):
                XCTFail("Failed with error: \(error)")
            case let .success(response):
                guard response.departures.count > 0 else {
                    XCTFail("Response contains no departures")
                    return
                }
                e.fulfill()
            }
        }

        waitForExpectations(timeout: 5)
    }

    func testDepartureMonitorWithNonExistantStopId() {
        let e = expectation(description: "Get ServiceError")

        let session = Session(cassetteName: #function)

        let date = Date(timeIntervalSince1970: 1490480797) // 2017-03-25 23:26:37
        Departure.monitor(stopWithId: "1337", date: date, session: session) { result in
            switch result {
            case let .failure(error):
                guard let error = error as? DVBError,
                    case let .request(status, message) = error else {
                    XCTFail("Error is not of correct type with metadata.")
                    return
                }
                XCTAssertEqual(status, "ServiceError")
                XCTAssertEqual(message, "stop invalid")
                e.fulfill()
            case .success:
                XCTFail("Shouldn't get successful response for non-existant stop ID.")
            }
        }

        waitForExpectations(timeout: 5)
    }
}
