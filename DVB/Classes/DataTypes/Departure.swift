//
//  Departure.swift
//  Pods
//
//  Created by Kilian Költzsch on 06/05/16.
//
//

import Foundation

/**
 *  A bus, tram or whatever leaving a specific stop at a specific time.
 */
public struct Departure {

    /// Line identifier, e.g. "3", "85" or "EV3".
    public let line: String

    /// Type of the Departure
    public var type: TransportMode.Monitor? {
        return parseType()
    }

    /// Destination of the departure, e.g. "Bühlau" or "Wilder Mann".
    public let direction: String

    /// How many minutes until the departure leaves.
    public let minutesUntil: Int

    /// Convenience getter for minutesUntil as NSDate
    public var leavingDate: Date {
        return Date().addingTimeInterval(Double(minutesUntil) * 60)
    }

    /**
     Init a Departure

     - parameter line:         Line identifier, e.g. "3", "85" or "EV3".
     - parameter direction:    Destination of the departure, e.g. "Bühlau" or "Wilder Mann".
     - parameter minutesUntil: How many minutes until the departure leaves.

     - returns: new Departure
     */
    public init(line: String, direction: String, minutesUntil: Int) {
        self.line = line
        self.direction = direction
        self.minutesUntil = minutesUntil
    }

    /**
     Use some magic to try to identify the type of the departure by it's line identifier.

     - returns: type
     */
    fileprivate func parseType() -> TransportMode.Monitor? {

        if let line = Int(line) {
            switch line {
            case 0 ... 20:
                return .Strassenbahn
            case 21 ..< 100:
                return .Stadtbus
            case 100 ... 1000:
                return .Regionalbus
            default:
                return nil
            }
        }

        // The next two are not necessarily always true. Not clue how this could possibly tell though.

        if let _ = line.range(of: "^E\\d", options: .regularExpression) {
            return .Strassenbahn
        }

        if let _ = line.range(of: "^E\\d\\d", options: .regularExpression) {
            return .Stadtbus
        }

        if let _ = line.range(of: "^F", options: .regularExpression) {
            return .Faehre
        }

        if let _ = line.range(of: "(^RE|^IC|^TL|^RB)", options: .regularExpression) {
            return .Zug
        }

        if let _ = line.range(of: "^S", options: .regularExpression) {
            return .SBahn
        }

        if let _ = line.range(of: "alita", options: .regularExpression) {
            // I believe this to be correct, but haven't been able to verify it :D
            return .ASTRufbus
        }

        if line == "SWB" {
            return .SeilSchwebebahn
        }

        return nil
    }
}

extension Departure: CustomStringConvertible {
    /// A textual representation of `self`.
    public var description: String {
        return "\(line) \(direction) departing in \(minutesUntil) minutes."
    }
}
