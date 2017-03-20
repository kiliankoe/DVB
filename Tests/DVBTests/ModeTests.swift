import Foundation
import XCTest
@testable import DVB

class ModeTests: XCTestCase {
    func testIdentifier() {
        XCTAssertEqual(Mode.Tram.identifier, "Tram")
        XCTAssertEqual(Mode.CityBus.identifier, "CityBus")
        XCTAssertEqual(Mode.IntercityBus.identifier, "IntercityBus")
        XCTAssertEqual(Mode.SuburbanRailway.identifier, "SuburbanRailway")
        XCTAssertEqual(Mode.Train.identifier, "Train")
        XCTAssertEqual(Mode.Cableway.identifier, "Cableway")
        XCTAssertEqual(Mode.Ferry.identifier, "Ferry")
        XCTAssertEqual(Mode.HailedSharedTaxi.identifier, "HailedSharedTaxi")
    }

    func testDvbIdentifier() {
        XCTAssertEqual(Mode.Tram.dvbIdentifier, "tram")
        XCTAssertEqual(Mode.CityBus.dvbIdentifier, "citybus")
        XCTAssertEqual(Mode.IntercityBus.dvbIdentifier, "bus")
        XCTAssertEqual(Mode.SuburbanRailway.dvbIdentifier, "metropolitan")
        XCTAssertEqual(Mode.Train.dvbIdentifier, "train")
        XCTAssertEqual(Mode.Cableway.dvbIdentifier, "lift")
        XCTAssertEqual(Mode.Ferry.dvbIdentifier, "ferry")
        XCTAssertEqual(Mode.HailedSharedTaxi.dvbIdentifier, "alita")

        XCTAssertEqual(Mode.Tram.iconURL.absoluteString, "https://www.dvb.de/assets/img/trans-icon/transport-tram.svg")
    }
}
