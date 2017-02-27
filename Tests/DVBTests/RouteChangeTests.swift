import Foundation
import XCTest
@testable import DVB

class RouteChangeTests: XCTestCase {
    func testFromJSON() {
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

    func testLineFromJSON() {
        let json: JSON = [
            "Id": "428946",
            "Name": "S 1",
            "TransportationCompany": "DB",
            "Mot": "SuburbanRailway",
            "Divas": [
                [
                    "Number": "10001",
                    "Network": "voe"
                ],
                [
                    "Number": "92D01",
                    "Network": "ddb"
                ]
            ],
            "Changes": [
                "509220"
            ]
        ]

        // swiftlint:disable:next force_try
        let line = try! RouteChange.Line(json: json)

        XCTAssertEqual(line.id, "428946")
        XCTAssertEqual(line.mode, .suburbanrailway)
        XCTAssertEqual(line.divas.first!.number, "10001")
    }
}
