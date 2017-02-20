import Foundation
import XCTest
@testable import DVB

class RouteChangeTests: XCTestCase {
    func testRouteChangeFromJSON() {
        let json: JSON = [
            "Id": "509243",
            "Type": "SomeRandomOtherType",
            "TripRequestInclude": true,
            "Title": "Gleisbau",
            "Description": "Hier könnte ein Text stehen.",
            "ValidityPeriods": [
                [
                    "Begin": "/Date(1487485800000+0100)/",
                    "End": "/Date(1487518200000+0100)/"
                ]
            ],
            "LineIds": [
                "428957"
            ],
            "PublishDate": "/Date(1486653360000+0100)/"
        ]

        // swiftlint:disable:next force_try
        let rc = try! RouteChange(json: json)
        XCTAssertEqual(rc.id, "509243")
        XCTAssertEqual(rc.lineIds.first!, "428957")
        XCTAssertEqual(rc.kind, RouteChange.Kind.other("SomeRandomOtherType"))
    }
}

#if os(Linux)
    extension RouteChangeTests {
        static var allTests: [(String, (RouteChangeTests) -> () throws -> Void)] {
            return [
                ("testRouteChangeFromJSON", testRouteChangeFromJSON),
            ]
        }
    }
#endif
