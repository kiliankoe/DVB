import Foundation
import XCTest
@testable import DVB

class DepartureTests: XCTestCase {
    func testDepartureETA() {
        let now = Date()
        let in5 = now.addingTimeInterval(5 * 60 + 1) // a second extra
        let platform = Departure.Platform(name: "3", type: "Platform")
        let diva = Diva(number: "11003", network: "voe")
        let dep = Departure(id: "123", line: "3", direction: "Wilder Mann", platform: platform, mode: .tram, realTime: in5, scheduledTime: now, state: .delayed, routeChanges: nil, diva: diva)

        XCTAssertEqual(dep.scheduledEta, 0)
        XCTAssertEqual(dep.actualEta, 5)
        XCTAssertEqual(dep.fancyEta, "0+5")
    }

    func testDepartureFromJSON() {
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
        let dep = Departure(json: json)!

        XCTAssertEqual(dep.line, "3")
        XCTAssertEqual(dep.direction, "Wilder Mann")
        XCTAssertEqual(dep.state, .onTime)
        XCTAssertEqual(dep.platform.name, "3")
        XCTAssertEqual(dep.routeChanges!.first!, "509223")
    }
}

#if os(Linux)
extension DepartureTests {
    static var allTests: [(String, (DepartureTests) -> () throws -> Void)] {
        return [
            ("testDepartureETA", testDepartureETA),
        ]
    }
}
#endif
