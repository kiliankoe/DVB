//
//  Departure.swift
//  Pods
//
//  Created by Kilian Költzsch on 06/05/16.
//
//

import Foundation

public struct MonitorResponse {
    public let stopName: String
    public let place: String
    public let expirationDate: Date
    public let departures: [Departure]
}

/// A bus, tram or whatever leaving a specific stop at a specific time
public struct Departure {
    public let id: String
    public let line: String
    public let direction: String
    public let platform: Platform
    public let mode: Mode
    public let realTime: Date
    public let scheduledTime: Date
    public let state: State
    public let routeChanges: [String]?
    public let diva: Diva

    public var eta: Int {
        return Int(realTime.timeIntervalSince(Date()) / 60)
    }

    public var fancyEta: String {
        let scheduledDiff = Int(scheduledTime.timeIntervalSince(Date()) / 60)
        let realDiff = Int(realTime.timeIntervalSince(scheduledTime) / 60)
        return "\(scheduledDiff)+\(realDiff)"
    }
}

// Namespacing some sub-types
extension Departure {
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

    public enum DateType {
        case arrival
        case departure

        var requestVal: Bool {
            return self == .arrival
        }
    }
}

// MARK: - JSON

extension MonitorResponse: FromJSON {
    init?(json: JSON) {
        guard let stopName = json["Name"] as? String,
            let place = json["Place"] as? String,
            let expirationStr = json["ExpirationTime"] as? String,
            let expirationDate = Date(from: expirationStr),
            let departures = json["Departures"] as? [JSON] else {
                return nil
        }

        self.stopName = stopName
        self.place = place
        self.expirationDate = expirationDate
        self.departures = departures.map{Departure.init(json: $0)}.flatMap{$0}
    }
}

extension Departure: FromJSON {
    init?(json: JSON) {
        guard let id = json["Id"] as? String,
            let line = json["LineName"] as? String,
            let direction = json["Direction"] as? String,
            let platformJson = json["Platform"], let platform = Platform(anyJSON: platformJson),
            let modeStr = json["Mot"] as? String, let mode = Mode(rawValue: modeStr.lowercased()),
            let realTimeStr = json["RealTime"] as? String, let realTime = Date(from: realTimeStr),
            let scheduledTimeStr = json["ScheduledTime"] as? String, let scheduledTime = Date(from: scheduledTimeStr),
            let stateStr = json["State"] as? String,
            let divaStr = json["Diva"], let diva = Diva(anyJSON: divaStr) else {
                return nil
        }

        self.id = id
        self.line = line
        self.direction = direction
        self.platform = platform
        self.mode = mode
        self.realTime = realTime
        self.scheduledTime = scheduledTime
        self.state = State(stateStr)
        self.routeChanges = json["RouteChanges"] as? [String]
        self.diva = diva
    }
}

extension Departure.Platform: FromJSON {
    init?(json: JSON) {
        guard let name = json["Name"] as? String,
            let type = json["Type"] as? String else { return nil }
        self.name = name
        self.type = type
    }
}

// MARK: - API

extension Departure {
    public static func monitor(id: String, date: Date = Date(), dateType: DateType = .arrival, allowedModes modes: [Mode] = Mode.all, allowShorttermChanges: Bool = true, completion: @escaping (Result<MonitorResponse>) -> Void) {
        let data: [String: Any] = [
            "stopid": id,
            "time": ISO8601DateFormatter().string(from: date),
            "isarrival": dateType.requestVal,
            "limit": 0,
            "shorttermchanges": allowShorttermChanges,
            "mot": modes.map{$0.identifier}
        ]

        post(Endpoint.departureMonitor, data: data, completion: completion)
    }
}

// MARK: - Utility

extension Departure: CustomStringConvertible {
    public var description: String {
        return "\(line) \(direction) departing in \(fancyEta) minutes."
    }
}

extension Departure: Equatable {}
public func == (lhs: Departure, rhs: Departure) -> Bool {
    return lhs.id == rhs.id
}

extension Departure: Hashable {
    public var hashValue: Int {
        return self.id.hashValue
    }
}

extension Departure.State: Equatable {}
public func == (lhs: Departure.State, rhs: Departure.State) -> Bool {
    switch (lhs, rhs) {
    case (.onTime, .onTime): return true
    case (.delayed, .delayed): return true
    case (.other(let x), .other(let y)): return x == y
    default: return false
    }
}
