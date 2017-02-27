import Foundation
import XCTest
@testable import DVB

class LineTests: XCTestCase {
    func testDescription() {
        let direction1 = Line.Direction(name: "Direction1", timetables: [])
        let direction2 = Line.Direction(name: "Direction2", timetables: [])
        let line = Line(name: "Line", mode: .tram, changes: [], directions: [direction1, direction2], diva: nil)

        XCTAssertEqual(line.description, "Line: Direction1, Direction2")
    }

    func testEquality() {
        let tt1 = Line.TimeTable(id: "TT", name: "")
        let tt2 = Line.TimeTable(id: "TT", name: "")

        let dir1 = Line.Direction(name: "Dir", timetables: [tt1])
        let dir2 = Line.Direction(name: "Dir", timetables: [tt2])

        let line1 = Line(name: "1", mode: .tram, changes: nil, directions: [dir1], diva: nil)
        let line2 = Line(name: "1", mode: .tram, changes: nil, directions: [dir2], diva: nil)

        XCTAssert(line1 == line2)
    }

    func testFromJSON() {
        let json: JSON = [
            "Name": "13",
            "Mot": "Tram",
            "Changes": [
                "509223"
            ],
            "Directions": [
                [
                    "Name": "Dresden Kaditz Riegelplatz",
                    "TimeTables": [
                        [
                            "Id": "voe:11013: :H:j17:1",
                            "Name": "Standardfahrplan 2017 - gültig ab 03.01.2017"
                        ]
                    ]
                ]
            ],
            "Diva": [
                "Number": "11013",
                "Network": "voe"
            ]
        ]

        do {
            let line = try Line(json: json)

            XCTAssertEqual(line.name, "13")
            XCTAssertEqual(line.directions[0].name, "Dresden Kaditz Riegelplatz")
            XCTAssertEqual(line.directions[0].timetables[0].id, "voe:11013: :H:j17:1")
        } catch {
            XCTFail("Failed to instantiate line from correct JSON")
        }
    }

    func testGet() {
        let e = expectation(description: "Find correct lines")

        Line.get(forId: "33000264") { result in
            switch result {
            case .failure(let error):
                XCTFail("Failed with error: \(error.localizedDescription)")
            case .success(let response):
                guard response.lines.count > 0 else {
                    XCTFail("Response contains no lines")
                    return
                }
                e.fulfill()
            }
        }

        waitForExpectations(timeout: 5)
    }

    func testGetWithName() {
        let e = expectation(description: "Find correct lines")

        Line.get(forName: "Postplatz") { result in
            switch result {
            case .failure(let error):
                XCTFail("Failed with error: \(error.localizedDescription)")
            case .success(let response):
                guard response.lines.count > 0 else {
                    XCTFail("Response contains no lines")
                    return
                }
                e.fulfill()
            }
        }

        waitForExpectations(timeout: 5)
    }
}
