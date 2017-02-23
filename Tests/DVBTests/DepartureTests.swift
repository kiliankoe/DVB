import Foundation
import XCTest
@testable import DVB

class DepartureTests: XCTestCase {
    func testETA() {
        let now = Date()
        let in5 = now.addingTimeInterval(5 * 60 + 1) // a second extra
        let platform = Departure.Platform(name: "3", type: "Platform")
        let diva = Diva(number: "11003", network: "voe")

        let dep1 = Departure(id: "123", line: "3", direction: "Wilder Mann", platform: platform, mode: .tram, realTime: in5, scheduledTime: now, state: .delayed, routeChanges: nil, diva: diva)
        XCTAssertEqual(dep1.scheduledEta, 0)
        XCTAssertEqual(dep1.actualEta, 5)

        let dep2 = Departure(id: "123", line: "3", direction: "Wilder Mann", platform: platform, mode: .tram, realTime: nil, scheduledTime: now, state: .delayed, routeChanges: nil, diva: diva)
        XCTAssertEqual(dep2.actualEta, nil)
    }

    func testFancyETA() {
        let now = Date()
        let in5 = now.addingTimeInterval(5 * 60 + 1)

        let dep1 = Departure(id: "", line: "", direction: "", platform: Departure.Platform(name: "", type: ""), mode: .tram, realTime: nil, scheduledTime: in5, state: .onTime, routeChanges: nil, diva: nil)
        XCTAssertEqual(dep1.fancyEta, "5")

        let dep2 = Departure(id: "", line: "", direction: "", platform: Departure.Platform(name: "", type: ""), mode: .tram, realTime: in5, scheduledTime: now, state: .onTime, routeChanges: nil, diva: nil)
        XCTAssertEqual(dep2.fancyEta, "0+5")

        let dep3 = Departure(id: "", line: "", direction: "", platform: Departure.Platform(name: "", type: ""), mode: .tram, realTime: now, scheduledTime: in5, state: .onTime, routeChanges: nil, diva: nil)
        XCTAssertEqual(dep3.fancyEta, "5-5")

        let dep4 = Departure(id: "", line: "", direction: "", platform: Departure.Platform(name: "", type: ""), mode: .tram, realTime: in5, scheduledTime: in5, state: .onTime, routeChanges: nil, diva: nil)
        XCTAssertEqual(dep4.fancyEta, "5")
    }

    func testEquality() {
        let dep1 = Departure(id: "123", line: "", direction: "", platform: Departure.Platform(name: "", type: ""), mode: .tram, realTime: nil, scheduledTime: Date(), state: .onTime, routeChanges: nil, diva: nil)
        let dep2 = Departure(id: "123", line: "", direction: "", platform: Departure.Platform(name: "", type: ""), mode: .tram, realTime: nil, scheduledTime: Date(), state: .onTime, routeChanges: nil, diva: nil)

        XCTAssert(dep1 == dep2)
    }

    func testDescription() {
        let dep = Departure(id: "123", line: "85", direction: "Löbtau", platform: Departure.Platform(name: "", type: ""), mode: .tram, realTime: nil, scheduledTime: Date(), state: .onTime, routeChanges: nil, diva: nil)

        XCTAssertEqual(dep.description, "85 Löbtau departing in 0 minutes.")
    }

    func testFromJSON() {
        let json: JSON = [
            "Id": "65533512",
            "LineName": "3",
            "Direction": "Wilder Mann",
            "Platform": [
                "Name": "3",
                "Type": "Platform"
            ],
            "Mot": "Tram",
            "RealTime": "/Date(1487453700000+0100)/",
            "ScheduledTime": "/Date(1487453700000+0100)/",
            "State": "InTime",
            "RouteChanges": [
                "509223"
            ],
            "Diva": [
                "Number": "11003",
                "Network": "voe"
            ]
        ]

        do {
            let dep = try Departure(json: json)

            XCTAssertEqual(dep.line, "3")
            XCTAssertEqual(dep.direction, "Wilder Mann")
            XCTAssertEqual(dep.state, .onTime)
            XCTAssertEqual(dep.platform.name, "3")
            XCTAssertEqual(dep.routeChanges!.first!, "509223")
        } catch {
            XCTFail("Failed to instantiate departure from correct JSON")
        }
    }

    func testFailingJSON() {
        let json: JSON = [
            "LineName": "3",
            "Direction": "Wilder Mann",
            "Platform": [
                "Name": "3",
                "Type": "Platform"
            ],
            "Mot": "Tram",
            "RealTime": "/Date(1487453700000+0100)/",
            "ScheduledTime": "/Date(1487453700000+0100)/",
            "State": "InTime",
            "RouteChanges": [
                "509223"
            ],
            "Diva": [
                "Number": "11003",
                "Network": "voe"
            ]
        ]

        do {
            _ = try Departure(json: json)
        } catch let e as DVBError {
            switch e {
            case .decode: break
            default: XCTFail("Expected decoding error, got: \(e.localizedDescription)")
            }
        } catch {
            XCTFail("Expected decoding error, got unexpected other error.")
        }
    }
}
