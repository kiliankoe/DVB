import Foundation
import XCTest
@testable import DVB

class ModeTests: XCTestCase {
    func testIdentifier() {
        XCTAssertEqual(Mode.Tram.identifier, "tram")
        XCTAssertEqual(Mode.CityBus.identifier, "citybus")
        XCTAssertEqual(Mode.IntercityBus.identifier, "bus")
        XCTAssertEqual(Mode.SuburbanRailway.identifier, "metropolitan")
        XCTAssertEqual(Mode.Train.identifier, "train")
        XCTAssertEqual(Mode.Cableway.identifier, "lift")
        XCTAssertEqual(Mode.Ferry.identifier, "ferry")
        XCTAssertEqual(Mode.HailedSharedTaxi.identifier, "alita")

        XCTAssertEqual(Mode.Tram.iconURL?.absoluteString, "https://www.dvb.de/assets/img/trans-icon/transport-tram.svg")
    }

    func testEquatable() {
        XCTAssertEqual(Mode.Tram, Mode.Tram)
        XCTAssertNotEqual(Mode.CityBus, Mode.Ferry)
    }
}
