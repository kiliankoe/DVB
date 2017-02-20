import Foundation
import XCTest
@testable import DVB

class LineTests: XCTestCase {
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

        let line = Line(json: json)!

        XCTAssertEqual(line.id, "428946")
        XCTAssertEqual(line.mode, .suburbanrailway)
        XCTAssertEqual(line.divas.first!.number, "10001")
    }
}

#if os(Linux)
    extension LineTests {
        static var allTests: [(String, (LineTests) -> () throws -> Void)] {
            return [
                ("testLineFromJSON", testLineFromJSON),
            ]
        }
    }
#endif
