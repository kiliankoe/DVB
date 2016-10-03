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
                expect(TransportMode.Departure(line: "3")) == .tram
                expect(TransportMode.Departure(line: "11")) == .tram
                expect(TransportMode.Departure(line: "59")) == .tram
                expect(TransportMode.Departure(line: "E8")) == .tram
                expect(TransportMode.Departure(line: "E11")) == .tram
                expect(TransportMode.Departure(line: "E")) == .tram
            }

            it("should identify correct values as 'bus'") {
                expect(TransportMode.Departure(line: "85")) == .bus
                expect(TransportMode.Departure(line: "99")) == .bus
                expect(TransportMode.Departure(line: "E75")) == .bus
                expect(TransportMode.Departure(line: "EV2")) == .bus
            }

            it("should identify correct values as 'regionalbus'") {
                expect(TransportMode.Departure(line: "366")) == .regionalbus
                expect(TransportMode.Departure(line: "999")) == .regionalbus
                expect(TransportMode.Departure(line: "A")) == .regionalbus
                expect(TransportMode.Departure(line: "Z")) == .regionalbus
                expect(TransportMode.Departure(line: "G/L")) == .regionalbus
                expect(TransportMode.Departure(line: "H/S")) == .regionalbus
            }

            it("should identify correct values as 'cablecar'") {
                expect(TransportMode.Departure(line: "SWB")) == .cablecar
            }

            it("should identify correct values as 'ferry'") {
                expect(TransportMode.Departure(line: "F7")) == .ferry
                expect(TransportMode.Departure(line: "F14")) == .ferry
            }

            it("should identify correct values as 'train'") {
                expect(TransportMode.Departure(line: "ICE 1717")) == .train
                expect(TransportMode.Departure(line: "IC 1818")) == .train
                expect(TransportMode.Departure(line: "RB 1919")) == .train
                expect(TransportMode.Departure(line: "TLX 2020")) == .train
                expect(TransportMode.Departure(line: "SB33")) == .train // "Sächsische Städtebahn"
                expect(TransportMode.Departure(line: "SE19")) == .train // "Wintersport Express" o.O
                expect(TransportMode.Departure(line: "U28")) == .train // fares between Bad Schandau and Děčín
            }

            it("should identify correct values as 'citytrain'") {
                expect(TransportMode.Departure(line: "S3")) == .citytrain
                expect(TransportMode.Departure(line: "S 2121")) == .citytrain
            }

            it("should identify correct values as 'oncallbus'") {
                expect(TransportMode.Departure(line: "alita")) == .oncallbus
                expect(TransportMode.Departure(line: "alita 95")) == .oncallbus
            }

            it("should fail with nil") {
                expect(TransportMode.Departure(line: "Lorem Ipsum")).to(beNil())
            }
        }
    }
}
