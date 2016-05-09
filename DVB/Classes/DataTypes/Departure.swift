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
    public var leavingDate: NSDate {
        return NSDate().dateByAddingTimeInterval(Double(minutesUntil) * 60)
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
    private func parseType() -> TransportMode.Monitor? {

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

        if let _ = line.rangeOfString("^E\\d", options: .RegularExpressionSearch) {
            return .Strassenbahn
        }

        if let _ = line.rangeOfString("^E\\d\\d", options: .RegularExpressionSearch) {
            return .Stadtbus
        }

        if let _ = line.rangeOfString("^F", options: .RegularExpressionSearch) {
            return .Faehre
        }

        if let _ = line.rangeOfString("(^RE|^IC|^TL|^RB)", options: .RegularExpressionSearch) {
            return .Zug
        }

        if let _ = line.rangeOfString("^S", options: .RegularExpressionSearch) {
            return .SBahn
        }

        if let _ = line.rangeOfString("alita", options: .RegularExpressionSearch) {
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
