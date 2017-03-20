import Foundation
import XCTest
import gausskrueger
@testable import DVB

class POITests: XCTestCase {
    func testSearchAltstadt() {
        let e = expectation(description: "Find some POIs")

        let northeast = GKCoordinate(x: 5660198, y: 4622956)
        let southwest = GKCoordinate(x: 5659219, y: 4622294)
        let coordRect = POI.CoordRect(northeast: northeast, southwest: southwest)

        POI.find(in: coordRect) { result in
            switch result {
            case .failure(let error):
                XCTFail("Failed with error: \(error)")
            case .success(let response):
                guard response.pins.count > 0 else {
                    XCTFail("Found no POIs")
                    return
                }
                e.fulfill()
            }
        }

        waitForExpectations(timeout: 5)
    }
}
