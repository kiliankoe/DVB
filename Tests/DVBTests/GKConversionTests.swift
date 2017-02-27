import Foundation
import XCTest
@testable import DVB

class GKConversionTests: XCTestCase {
    func testGKtoWGS() {
        let gk = (x: 4591270.0, y: 5819620.0)
        guard let wgs = Coordinate(x: gk.x, y: gk.y) else { XCTFail(); return }

        XCTAssertEqual(wgs.latitude, 52.502133988116455)
        XCTAssertEqual(wgs.longitude, 13.342517405215336)
    }

    func testWGStoGK() {
        let wgs = Coordinate(latitude: 52.502133988116455, longitude: 13.342517405215336)
        guard let gk = wgs.asGK else { XCTFail(); return }

        XCTAssertEqual(gk.x, 4591270)
        XCTAssertEqual(gk.y, 5819620)
    }
}
