import Foundation
import XCTest
@testable import DVB

class ModeTests: XCTestCase {
    func testIdentifier() {
        XCTAssertEqual(Mode.tram.identifier, "Tram")
        XCTAssertEqual(Mode.citybus.identifier, "CityBus")
        XCTAssertEqual(Mode.intercitybus.identifier, "IntercityBus")
        XCTAssertEqual(Mode.suburbanrailway.identifier, "SuburbanRailway")
        XCTAssertEqual(Mode.train.identifier, "Train")
        XCTAssertEqual(Mode.cableway.identifier, "Cableway")
        XCTAssertEqual(Mode.ferry.identifier, "Ferry")
        XCTAssertEqual(Mode.hailedsharedtaxi.identifier, "HailedSharedTaxi")
    }

    func testDvbIdentifier() {
        XCTAssertEqual(Mode.tram.dvbIdentifier, "tram")
        XCTAssertEqual(Mode.citybus.dvbIdentifier, "citybus")
        XCTAssertEqual(Mode.intercitybus.dvbIdentifier, "bus")
        XCTAssertEqual(Mode.suburbanrailway.dvbIdentifier, "metropolitan")
        XCTAssertEqual(Mode.train.dvbIdentifier, "train")
        XCTAssertEqual(Mode.cableway.dvbIdentifier, "lift")
        XCTAssertEqual(Mode.ferry.dvbIdentifier, "ferry")
        XCTAssertEqual(Mode.hailedsharedtaxi.dvbIdentifier, "alita")

        XCTAssertEqual(Mode.tram.iconURL.absoluteString, "https://www.dvb.de/assets/img/trans-icon/transport-tram.svg")
    }
}
