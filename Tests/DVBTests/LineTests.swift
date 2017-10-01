import Foundation
import XCTest
@testable import DVB

class LineTests: XCTestCase {
    func testDescription() {
        let direction1 = Line.Direction(name: "Direction1", timetables: [])
        let direction2 = Line.Direction(name: "Direction2", timetables: [])
        let line = Line(name: "Line", mode: .Tram, changes: [], directions: [direction1, direction2], diva: nil)

        XCTAssertEqual(line.description, "Line: Direction1, Direction2")
    }

    func testEquality() {
        let tt1 = Line.TimeTable(id: "TT", name: "")
        let tt2 = Line.TimeTable(id: "TT", name: "")

        let dir1 = Line.Direction(name: "Dir", timetables: [tt1])
        let dir2 = Line.Direction(name: "Dir", timetables: [tt2])

        let line1 = Line(name: "1", mode: .Tram, changes: nil, directions: [dir1], diva: nil)
        let line2 = Line(name: "1", mode: .Tram, changes: nil, directions: [dir2], diva: nil)

        XCTAssert(line1 == line2)
    }

    func testGetLinesAtGoerlitzer() {
        let e = expectation(description: "Find correct lines")

        let session = Session(cassetteName: #function)

        let goerlitzerStraße = "33000264"
        Line.get(forStopId: goerlitzerStraße, session: session) { result in
            switch result {
            case .failure(let error):
                XCTFail("Failed with error: \(error)")
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

    func testGetLinesAtPostplatzWithName() {
        let e = expectation(description: "Find correct lines")

        let session = Session(cassetteName: #function)

        session.beginRecording()

        Line.get(forStopName: "Postplatz", session: session) { result in
            session.endRecording()

            switch result {
            case .failure(let error):
                XCTFail("Failed with error: \(error)")
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
