import Foundation
import XCTest
import DVB

class MonitorTests: XCTestCase {
    func testDepartureMonitor() {
        let e = expectation(description: "Find correct departures")

        Departure.monitor(id: "33000037") { result in
            switch result {
            case .failure(let error):
                XCTFail("Failed with error: \(error.localizedDescription)")
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

        Departure.monitor(name: "Albertplatz") { result in
            switch result {
            case .failure(let error):
                XCTFail("Failed with error: \(error.localizedDescription)")
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

        Departure.monitor(id: "1337") { result in
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

#if os(Linux)
    extension MonitorTests {
        static var allTests: [(String, (MonitorTests) -> () throws -> Void)] {
            return [
                ("testDepartureMonitor", testDepartureMonitor),
                ("testMonitorWithName", testMonitorWithName),
                ("testNonExistantStopId", testNonExistantStopId),
            ]
        }
    }
#endif
