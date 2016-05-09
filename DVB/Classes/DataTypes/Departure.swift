//
//  Departure.swift
//  Pods
//
//  Created by Kilian Költzsch on 06/05/16.
//
//

import Foundation

/**
 *  A departure is a bus or tram leaving a specific stop at a specific time.
 */
public struct Departure {

    /// Line identifier, e.g. "3", "85" or "EV3".
    public let line: String

    /// Type of the Departure
    /// Beware that this is currently very prone to failure and inaccurate...
    public var type: TransportMode? {
        // TODO: Improve on this...
        let lineInt = Int(line)
        switch lineInt {
        case .Some(0 ... 20):
            return .Straßenbahn
        case .Some(21 ..< 100):
            return .Stadtbus
        case .Some(100 ... 1000):
            return .Regionalbus
        default:
            return nil
        }
    }

    /// Destination of the departure, e.g. "Bühlau" or "Wilder Mann".
    public let direction: String

    /// How many minutes until the departure leaves.
    public let minutesUntil: Int

    /// Convenience getter for minutesUntil as NSDate
    public var leavingDate: NSDate {
        return NSDate().dateByAddingTimeInterval(Double(minutesUntil) * 60)
    }

    public init(line: String, direction: String, minutesUntil: Int) {
        self.line = line
        self.direction = direction
        self.minutesUntil = minutesUntil
    }
}

extension Departure: CustomStringConvertible {
    public var description: String {
        return "\(line) \(direction) departing in \(minutesUntil) minutes."
    }
}
