import Foundation
import XCTest
import DVB
import struct CoreLocation.CLLocationCoordinate2D

class FindTests: XCTestCase {
    func testFindHelmholtzQuery() {
        let e = expectation(description: "Find correct stop")

        Stop.find(query: "Helmholtz") { result in
            switch result {
            case .failure(let e):
                XCTFail("Failed with error: \(e.localizedDescription)")
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
//        let coordinate = CLLocationCoordinate2D(latitude: 51.031658, longitude: 13.727130)
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

#if os(Linux)
    extension FindTests {
        static var allTests: [(String, (FindTests) -> () throws -> Void)] {
            return [
                ("testFindHelmholtzQuery", testFindHelmholtzQuery),
            ]
        }
    }
#endif
