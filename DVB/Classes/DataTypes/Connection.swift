//
//  Connection.swift
//  Pods
//
//  Created by Kilian Költzsch on 06/05/16.
//
//

import Foundation

/**
 *  A connection is a bus or tram leaving a specific stop at a specific time.
 */
public struct Connection {

    /// Line identifier, e.g. "3", "85" or "EV3".
    public let line: String

    /// Is the line a bus or tram? Can be nil if line ID contains letters.
    public var isBus: Bool? {
        if let line = Int(line) {
            return line > 20
        }
        return nil
    }

    /// Destination of the connection, e.g. "Bühlau" or "Wilder Mann".
    public let direction: String

    /// How many minutes until the connection leaves.
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

extension Connection: CustomStringConvertible {
    public var description: String {
        return "\(line) \(direction) departing in \(minutesUntil) minutes."
    }
}
