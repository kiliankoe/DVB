import XCTest
import DVB

class GaussKruegerTests: XCTestCase {
    func testGKtoWGS() {
        let gk = GKCoordinate(x: 4591270, y: 5819620)
        guard let wgs = gk.asWGS else { XCTFail("failed to convert gk to wgs coordinate"); return }

        XCTAssertEqual(wgs.latitude, 52.502133988116455)
        XCTAssertEqual(wgs.longitude, 13.342517405215336)
    }

    func testWGStoGK() {
        let wgs = WGSCoordinate(latitude: 52.502133988116455, longitude: 13.342517405215336)
        guard let gk = wgs.asGK else { XCTFail("failed to convert wgs to gk coordinate"); return }

        XCTAssertEqual(gk.x, 4591270)
        XCTAssertEqual(gk.y, 5819620)
    }
}
