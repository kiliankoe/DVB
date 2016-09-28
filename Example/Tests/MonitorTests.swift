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
