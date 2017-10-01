import Foundation
import XCTest
import GaussKrueger
@testable import DVB

class POITests: XCTestCase {
    func testPOISearchAltstadt() {
        let e = expectation(description: "Find some POIs")

        let session = Session(cassetteName: #function)

        let northeast = GKCoordinate(x: 5_660_198, y: 4_622_956)
        let southwest = GKCoordinate(x: 5_659_219, y: 4_622_294)
        let coordRect = POI.CoordRect(northeast: northeast, southwest: southwest)

        POI.find(in: coordRect, session: session) { result in
            switch result {
            case let .failure(error):
                XCTFail("Failed with error: \(error)")
            case let .success(response):
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
