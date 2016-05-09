//
//  FindTests.swift
//  DVB
//
//  Created by Kilian Költzsch on 09/05/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import DVB

class FindTests: QuickSpec {
    override func spec() {
        describe("Stop struct") {
            let stop = Stop(name: "Helmholtzstraße", location: "Dresden")

            it("should have the correct name") {
                expect(stop.name) == "Helmholtzstraße"
            }

            it("should have the correct location") {
                expect(stop.location) == "Dresden"
            }
        }

        describe("DVB.find") {

            it("should return results") {
                DVB.find("Helmholtzstraße", completion: { (stops) in
                    expect(stops.count) > 0
                })
            }

            it("should return the correct stops") {
                DVB.find("Zellesch", completion: { (stops) in
                    expect(stops.first!.name) == "Zellescher Weg"
                })
            }
        }
    }
}
