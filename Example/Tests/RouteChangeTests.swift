//
//  RouteChangeTests.swift
//  DVB
//
//  Created by Kilian Költzsch on 09/05/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import DVB

class RouteChangeTests: QuickSpec {
    override func spec() {
        describe("RouteChange Struct") {
            let routeChange = RouteChange(title: "DVB Linie 85: Dresden - Hepkestraße, halbseitige Sperrung", rawDetails: "These are some details")

            it("should have the correct title") {
                expect(routeChange.title) == "DVB Linie 85: Dresden - Hepkestraße, halbseitige Sperrung"
            }

            it("should have the correct details") {
                expect(routeChange.rawDetails) == "These are some details"
            }

            it("should be for the correct line") {
                expect(routeChange.affectedLine) == "85"
            }
        }

        describe("DVB.routeChanges") {

            it("should return data") {
                DVB.routeChanges({ (updated, routeChanges) in
                    expect(updated) != nil
                })
            }
        }
    }
}
