//
//  TransportModeTests.swift
//  DVB
//
//  Created by Kilian Költzsch on 03/10/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import DVB

class TransportModeTests: QuickSpec {
    // swiftlint:disable:next function_body_length
    override func spec() {
        describe("TransportMode") {
            it("should identify correct values as 'tram'") {
                expect(TransportMode.Departures(line: "3")) == .tram
                expect(TransportMode.Departures(line: "11")) == .tram
                expect(TransportMode.Departures(line: "59")) == .tram
                expect(TransportMode.Departures(line: "E8")) == .tram
                expect(TransportMode.Departures(line: "E11")) == .tram
                expect(TransportMode.Departures(line: "E")) == .tram
            }

            it("should identify correct values as 'bus'") {
                expect(TransportMode.Departures(line: "85")) == .bus
                expect(TransportMode.Departures(line: "99")) == .bus
                expect(TransportMode.Departures(line: "E75")) == .bus
                expect(TransportMode.Departures(line: "EV2")) == .bus
            }

            it("should identify correct values as 'regionalbus'") {
                expect(TransportMode.Departures(line: "366")) == .regionalbus
                expect(TransportMode.Departures(line: "999")) == .regionalbus
                expect(TransportMode.Departures(line: "A")) == .regionalbus
                expect(TransportMode.Departures(line: "Z")) == .regionalbus
                expect(TransportMode.Departures(line: "G/L")) == .regionalbus
                expect(TransportMode.Departures(line: "H/S")) == .regionalbus
            }

            it("should identify correct values as 'cablecar'") {
                expect(TransportMode.Departures(line: "SWB")) == .cablecar
            }

            it("should identify correct values as 'ferry'") {
                expect(TransportMode.Departures(line: "F7")) == .ferry
                expect(TransportMode.Departures(line: "F14")) == .ferry
            }

            it("should identify correct values as 'train'") {
                expect(TransportMode.Departures(line: "ICE 1717")) == .train
                expect(TransportMode.Departures(line: "IC 1818")) == .train
                expect(TransportMode.Departures(line: "RB 1919")) == .train
                expect(TransportMode.Departures(line: "TLX 2020")) == .train
                expect(TransportMode.Departures(line: "SB33")) == .train // "Sächsische Städtebahn"
                expect(TransportMode.Departures(line: "SE19")) == .train // "Wintersport Express" o.O
                expect(TransportMode.Departures(line: "U28")) == .train // fares between Bad Schandau and Děčín
            }

            it("should identify correct values as 'citytrain'") {
                expect(TransportMode.Departures(line: "S3")) == .citytrain
                expect(TransportMode.Departures(line: "S 2121")) == .citytrain
            }

            it("should identify correct values as 'oncallbus'") {
                expect(TransportMode.Departures(line: "alita")) == .oncallbus
                expect(TransportMode.Departures(line: "alita 95")) == .oncallbus
            }

            it("should fail with nil") {
                expect(TransportMode.Departures(line: "Lorem Ipsum")) == nil
            }
        }
    }
}
