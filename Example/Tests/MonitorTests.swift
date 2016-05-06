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
        describe("Testing Connection Struct") {
            let con = Connection(line: "3", direction: "Wilder Mann", minutesUntil: 5)

            it("should be the correct line") {
                expect(con.line) == "3"
            }

            it("should have the correct direction") {
                expect(con.direction) == "Wilder Mann"
            }

            it("should have the correct minutesUntil") {
                expect(con.minutesUntil) == 5
            }

            it("should identify as the correct type") {
                expect(con.isBus) == false
            }

            it("should have a correct NSDate") {
                let in5Minutes = NSDate().dateByAddingTimeInterval(5 * 60)
                // There will be small differences in the creation of the two NSDates
                expect(con.leavingDate.timeIntervalSince1970 - in5Minutes.timeIntervalSince1970) < 1
            }
        }

        describe("Testing Monitor Method") {

            it("should return results") {
                DVB.monitor("Postplatz", completion: { (connections) in
                    expect(connections.count) > 0
                })
            }

            it("shouldn't find results for unknown stop") {
                DVB.monitor("foobarbaz", completion: { (connections) in
                    expect(connections.count) == 0
                })
            }

            it("should only return requested lines") {
                DVB.monitor("Pirnaischer Platz", line: "3", completion: { (connections) in
                    for con in connections {
                        expect(con.line) == "3"
                    }
                })
            }
        }
    }
}
