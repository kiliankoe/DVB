//
//  DepartureTests.swift
//  DVB
//
//  Created by Kilian Költzsch on 28/09/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import DVB

class DepartureTests: QuickSpec {
    override func spec() {
        describe("Departure") {
            let dep = Departure(line: "3", direction: "Wilder Mann", minutesUntil: 5)

            it("should be the correct line") {
                expect(dep.line) == "3"
            }

            it("should have the correct direction") {
                expect(dep.direction) == "Wilder Mann"
            }

            it("should have the correct minutesUntil") {
                expect(dep.eta) == 5
            }

            it("should identify as the correct type") {
                expect(dep.type) == .tram
            }

            it("should have the correct type identifier") {
                expect(dep.type?.identifier) == .some("tram")
            }

            it("should have a correct date") {
                let in5Minutes = Date().addingTimeInterval(5 * 60)
                // There will be a small difference in the creation of the two Dates
                expect(dep.departingAt.timeIntervalSince1970).to(beCloseTo(in5Minutes.timeIntervalSince1970, within: 1))
            }
        }
    }
}
