//
//  MonitorTests.swift
//  DVB
//
//  Created by Kilian Költzsch on 07/05/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import DVB

class MonitorTests: QuickSpec {
    override func spec() {
        describe("Departure Struct") {
            let dep = Departure(line: "3", direction: "Wilder Mann", minutesUntil: 5)

            it("should be the correct line") {
                expect(dep.line) == "3"
            }

            it("should have the correct direction") {
                expect(dep.direction) == "Wilder Mann"
            }

            it("should have the correct minutesUntil") {
                expect(dep.minutesUntil) == 5
            }

            it("should identify as the correct type") {
                expect(dep.type) == .Strassenbahn
            }

            it("should have a correct NSDate") {
                let in5Minutes = NSDate().dateByAddingTimeInterval(5 * 60)
                // There will be small differences in the creation of the two NSDates
                expect(dep.leavingDate.timeIntervalSince1970 - in5Minutes.timeIntervalSince1970) < 1
            }
        }

        describe("DVB.monitor") {

            it("should return results") {
                DVB.monitor("Postplatz", completion: { (departures) in
                    expect(departures.count) > 0
                })
            }

            it("shouldn't find results for unknown stop") {
                DVB.monitor("foobarbaz", completion: { (departures) in
                    expect(departures.count) == 0
                })
            }

            it("should only return requested lines") {
                DVB.monitor("Pirnaischer Platz", line: ["3"], completion: { (departures) in
                    for dep in departures {
                        expect(dep.line) == "3"
                    }
                })
            }

            it("shouldn't fail on high limit") {
                DVB.monitor("Postplatz", limit: 500, completion: { (departures) in
                    expect(departures.count) > 0
                })
            }

            it("shouldn't fail on a negative limit") {
                DVB.monitor("Postplatz", limit: -1, completion: { (departures) in
                    expect(true) == true
                })
            }
        }
    }
}
