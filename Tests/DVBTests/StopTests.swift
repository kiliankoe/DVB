import Foundation
import XCTest
@testable import DVB

class StopTests: XCTestCase {
    func testDescription() {
        let stop1 = Stop(id: "", name: "Stop", region: nil, location: nil)
        XCTAssertEqual(stop1.description, "Stop")

        let stop2 = Stop(id: "", name: "Stop", region: "", location: nil)
        XCTAssertEqual(stop2.description, "Stop")

        let stop3 = Stop(id: "", name: "Stop", region: "Region", location: nil)
        XCTAssertEqual(stop3.description, "Stop, Region")
    }

    func testFromString() {
        let string = "33000742|||Helmholtzstraße|5655904|4621157|0||"
        // swiftlint:disable:next force_try
        let stop = try! Stop(string: string)

        XCTAssertEqual(stop.id, "33000742")
        XCTAssertEqual(stop.name, "Helmholtzstraße")
        XCTAssertEqual(stop.region, nil)
        XCTAssertEqual(stop.location?.latitude, 51.025570859830559)
        XCTAssertEqual(stop.location?.longitude, 13.72543580275704)
    }

    func testFromInvalidString() {
        let string = "33000742|||Helmholtzstraße|5655904|4621157|0|"
        do {
            _ = try Stop(string: string)
        } catch let e as DVBError {
            switch e {
            case .decode: break
            default: XCTFail("Got unexpected error type")
            }
        } catch {
            XCTFail("Got unexpected error type")
        }
    }

    func testEquality() {
        let stop1 = Stop(id: "123", name: "", region: nil, location: nil)
        let stop2 = Stop(id: "123", name: "", region: nil, location: nil)

        XCTAssert(stop1 == stop2)
    }

    func testFindHelmholtzQuery() {
        let e = expectation(description: "Find correct stop")

        Stop.find("Helmholtz") { result in
            switch result {
            case .failure(let error):
                XCTFail("Failed with error: \(error)")
            case .success(let response):
                guard let helmholtz = response.stops.first else {
                    XCTFail("Response contains no stops")
                    return
                }
                XCTAssertEqual(helmholtz.name, "Helmholtzstraße")
                e.fulfill()
            }
        }

        waitForExpectations(timeout: 5)
    }

    //    func testFindNear() {
    //        let e = expectation(description: "Find stops near coordinate")
    //
    //        let coordinate = Coordinate(latitude: 51.031658, longitude: 13.727130)
    //        Stop.findNear(coord: coordinate) { result in
    //            switch result {
    //            case .failure(let e):
    //                XCTFail("Failed with error: \(e.localizedDescription)")
    //            case .success(let response):
    //                guard response.stops.count > 0 else {
    //                    XCTFail("Response contains no stops")
    //                    return
    //                }
    //                e.fulfill()
    //            }
    //        }
    //
    //        waitForExpectations(timeout: 5)
    //    }
}
