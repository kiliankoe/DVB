import Foundation
import XCTest
@testable import DVB

// swiftlint:disable identifier_name

class DepartureTests: XCTestCase {
    func testETA() {
        let now = Date()
        let in5 = now.addingTimeInterval(5 * 60 + 1) // a second extra
        let platform = Platform(name: "3", type: "Platform")
        let diva = Diva(number: "11003", network: "voe")

        let dep1 = Departure(id: "123", line: "3", direction: "Wilder Mann", platform: platform, mode: .Tram, realTime: in5, scheduledTime: now, state: .delayed, routeChanges: nil, diva: diva)
        XCTAssertEqual(dep1.scheduledETA, 0)
        XCTAssertEqual(dep1.ETA, 5)

        let dep2 = Departure(id: "123", line: "3", direction: "Wilder Mann", platform: platform, mode: .Tram, realTime: nil, scheduledTime: now, state: .delayed, routeChanges: nil, diva: diva)
        XCTAssertEqual(dep2.ETA, 0)
    }

    func testFancyETA() {
        let now = Date()
        let in5 = now.addingTimeInterval(5 * 60 + 1)

        let dep1 = Departure(id: "", line: "", direction: "", platform: Platform(name: "", type: ""), mode: .Tram, realTime: nil, scheduledTime: in5, state: .onTime, routeChanges: nil, diva: nil)
        XCTAssertEqual(dep1.fancyETA, "5")

        let dep2 = Departure(id: "", line: "", direction: "", platform: Platform(name: "", type: ""), mode: .Tram, realTime: in5, scheduledTime: now, state: .onTime, routeChanges: nil, diva: nil)
        XCTAssertEqual(dep2.fancyETA, "0+5")

        let dep3 = Departure(id: "", line: "", direction: "", platform: Platform(name: "", type: ""), mode: .Tram, realTime: now, scheduledTime: in5, state: .onTime, routeChanges: nil, diva: nil)
        XCTAssertEqual(dep3.fancyETA, "5-5")

        let dep4 = Departure(id: "", line: "", direction: "", platform: Platform(name: "", type: ""), mode: .Tram, realTime: in5, scheduledTime: in5, state: .onTime, routeChanges: nil, diva: nil)
        XCTAssertEqual(dep4.fancyETA, "5")
    }

    func testLocalizedETA() {
        let now = Date()
        let in1 = now.addingTimeInterval(60 + 1)
        let in5 = now.addingTimeInterval(5 * 60 + 1)

        let deLocale = Locale(identifier: "de_DE")
        let enLocale = Locale(identifier: "en_US")

        let de1 = Departure(id: "", line: "", direction: "", platform: Platform(name: "", type: ""), mode: .Tram, realTime: nil, scheduledTime: now, state: .onTime, routeChanges: nil, diva: nil)
        XCTAssertEqual(de1.localizedETA(for: deLocale), "jetzt")
        let de2 = Departure(id: "", line: "", direction: "", platform: Platform(name: "", type: ""), mode: .Tram, realTime: nil, scheduledTime: in1, state: .onTime, routeChanges: nil, diva: nil)
        XCTAssertEqual(de2.localizedETA(for: deLocale), "1 Minute")
        let de3 = Departure(id: "", line: "", direction: "", platform: Platform(name: "", type: ""), mode: .Tram, realTime: nil, scheduledTime: in5, state: .onTime, routeChanges: nil, diva: nil)
        XCTAssertEqual(de3.localizedETA(for: deLocale), "5 Minuten")

        let en1 = Departure(id: "", line: "", direction: "", platform: Platform(name: "", type: ""), mode: .Tram, realTime: nil, scheduledTime: now, state: .onTime, routeChanges: nil, diva: nil)
        XCTAssertEqual(en1.localizedETA(for: enLocale), "now")
        let en2 = Departure(id: "", line: "", direction: "", platform: Platform(name: "", type: ""), mode: .Tram, realTime: nil, scheduledTime: in1, state: .onTime, routeChanges: nil, diva: nil)
        XCTAssertEqual(en2.localizedETA(for: enLocale), "1 minute")
        let en3 = Departure(id: "", line: "", direction: "", platform: Platform(name: "", type: ""), mode: .Tram, realTime: nil, scheduledTime: in5, state: .onTime, routeChanges: nil, diva: nil)
        XCTAssertEqual(en3.localizedETA(for: enLocale), "5 minutes")
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

        let postplatz = "33000037"
        Departure.monitor(stopWithId: postplatz, date: Date()) { result in
            switch result {
            case let .failure(error):
                XCTFail("Failed with error: \(error)")
                e.fulfill()
            case let .success(response):
                XCTAssertGreaterThan(response.departures.count, 0)
                e.fulfill()
            }
        }

        waitForExpectations(timeout: 5)
    }

    func testDepartureMonitorAtHauptbahnhofWithName() {
        let e = expectation(description: "Find correct departures")

        Departure.monitor(stopWithName: "Hauptbahnhof", date: Date()) { result in
            switch result {
            case let .failure(error):
                XCTFail("Failed with error: \(error)")
                e.fulfill()
            case let .success(response):
                XCTAssertGreaterThan(response.departures.count, 0)
                e.fulfill()
            }
        }

        waitForExpectations(timeout: 5)
    }

    func testDepartureMonitorWithNonExistantStopId() {
        let e = expectation(description: "Get ServiceError")

        Departure.monitor(stopWithId: "1337", date: Date()) { result in
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
