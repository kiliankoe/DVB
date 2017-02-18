//
//  Departure.swift
//  Pods
//
//  Created by Kilian Költzsch on 06/05/16.
//
//

import Foundation

public struct MonitorResponse {
    let name: String
    let place: String
    let expirationDate: Date?
    let departures: [Departure]

    init?(json: [String: Any]) {
        return nil
    }
}

/// A bus, tram or whatever leaving a specific stop at a specific time
public struct Departure {
    public struct Platform {
        let name: String
        let type: String
    }

    public enum State {
        case onTime
        case delayed
        case other(String) // TODO: Figure out what these are. "Cancelled" maybe? And others?

        init(_ string: String) {
            switch string {
            case "InTime":
                self = .onTime
            case "Delayed":
                self = .delayed
            default:
                self = .other(string)
            }
        }
    }

    public let id: String
    public let line: String
    public let direction: String
    public let platform: Platform
    public let mode: Mode
    public let realTime: Date
    public let scheduledTime: Date
    public let state: State
    public let diva: Diva

    var eta: Int {
        return Int(realTime.timeIntervalSince(Date()) / 60)
    }

    var fancyEta: String {
        let scheduledDiff = Int(scheduledTime.timeIntervalSince(Date()) / 60)
        let realDiff = Int(realTime.timeIntervalSince(scheduledTime) / 60)
        return "\(scheduledDiff)+\(realDiff)"
    }
}

extension Departure: CustomStringConvertible {
    /// A textual representation of `self`.
    public var description: String {
        return "\(line) \(direction) departing in \(eta) minutes."
    }
}
