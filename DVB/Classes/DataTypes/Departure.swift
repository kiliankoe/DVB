//
//  Departure.swift
//  Pods
//
//  Created by Kilian Költzsch on 06/05/16.
//
//

import Foundation

/// A bus, tram or whatever leaving a specific stop at a specific time
public struct Departure {

    /// Line identifier, e.g. "3", "85" or "EV3"
    public let line: String

    /// Type of the Departure
    /// - warning: This is only a best guess approximation and might fail. Substitute lines are especially hard.
    ///   Should you ever find inconsistencies (especially if nil is returned), please tell me about it and open an issue. Thanks! 🙂
    ///   https://github.com/kiliankoe/DVB/issues/new
    public var type: TransportMode.Departure? {
        return TransportMode.Departure(line: line)
    }

    /// Destination of the departure, e.g. "Bühlau", "Wilder Mann" etc.
    public let direction: String

    /// How many minutes until the departure leaves
    public let minutesUntil: UInt

    /// Convenience getter for minutesUntil as Date
    public var leavingDate: Date {
        return Date().addingTimeInterval(Double(minutesUntil) * 60)
    }

    /// Initialize a Departure
    ///
    /// - parameter line:         Line identifier, e.g. "3", "85", "EV7", etc.
    /// - parameter direction:    Destination of the departure, e.g. "Bühlau", "Wilder Mann", etc.
    /// - parameter minutesUntil: Minutes until departure
    ///
    /// - returns: Departure
    public init(line: String, direction: String, minutesUntil: UInt) {
        self.line = line
        self.direction = direction
        self.minutesUntil = minutesUntil
    }

    /// Internal convenience initializer from a JSON object
    ///
    /// - parameter json: JSON object
    ///
    /// - returns: Departure
    init?(json: Any) {
        guard let list = json as? [String] else { return nil }
        guard list.count >= 3 else { return nil }

        self.line = list[0]
        self.direction = list[1]
        self.minutesUntil = UInt(list[2]) ?? 0
    }
}

extension Departure: CustomStringConvertible {
    /// A textual representation of `self`.
    public var description: String {
        return "\(line) \(direction) departing in \(minutesUntil) minutes."
    }
}
