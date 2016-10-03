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
        describe("DVB.find") {
            it("should return results") {
                let stops = DVB.find(query: "Helmholtzstraße")
                expect(stops.count) > 0
            }

            it("should return the correct stops") {
                let stops = DVB.find(query: "Zellesch")
                expect(stops.first!.name) == "Zellescher Weg"
            }
        }

        describe("DVB.nearestStops") {
            it("should return correct results") {
                let (helmholtz, distance) = DVB.findNear(latitude: 51.0271761, longitude: 13.7258114, radius: 300).first!
                expect(helmholtz.name) == "Helmholtzstraße"
				expect(distance) <= 300
            }
        }
    }
}
