//
//  Date+fromString.swift
//  Pods
//
//  Created by Kilian Költzsch on 18/02/2017.
//
//

import Foundation

internal extension Date {
    // Init with a string of the format "/Date(1487458060455+0100)/"
    init?(from dateString: String) {
        let components = dateString
            .replacingOccurrences(of: "/Date(", with: "")
            .replacingOccurrences(of: ")/", with: "")
            .components(separatedBy: "+") // FIXME: This will surely break...

        guard let millis = Int(components[0]) else { return nil }
        guard let tz = Int(components[1]) else { return nil }

        let seconds = Double(millis) / 1000 + Double(tz/100 * 60 * 60)
        self = Date(timeIntervalSince1970: seconds)
    }
}
