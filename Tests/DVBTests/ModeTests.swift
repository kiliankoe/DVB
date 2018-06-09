import Foundation
import XCTest
@testable import DVB

class ModeTests: XCTestCase {
    func testIdentifier() {
        XCTAssertEqual(Mode.tram.rawValue, "tram")
        XCTAssertEqual(Mode.cityBus.rawValue, "citybus")
        XCTAssertEqual(Mode.intercityBus.rawValue, "intercitybus")
        XCTAssertEqual(Mode.suburbanRailway.rawValue, "suburbanrailway")
        XCTAssertEqual(Mode.train.rawValue, "train")
        XCTAssertEqual(Mode.cableway.rawValue, "lift")
        XCTAssertEqual(Mode.ferry.rawValue, "ferry")
        XCTAssertEqual(Mode.hailedSharedTaxi.rawValue, "alita")

        XCTAssertEqual(Mode.footpath.rawValue, "footpath")
        XCTAssertEqual(Mode.rapidTransit.rawValue, "rapidtransit")

        XCTAssertEqual(Mode.tram.iconURL?.absoluteString, "https://www.dvb.de/assets/img/trans-icon/transport-tram.svg")
    }

    func testEquatable() {
        XCTAssertEqual(Mode.tram, Mode.tram)
        XCTAssertNotEqual(Mode.cityBus, Mode.ferry)
    }
}
