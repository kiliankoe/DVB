import Foundation
import Marshal

public struct MonitorResponse {
    public let stopName: String
    public let place: String
    public let expirationTime: Date
    public let departures: [Departure]
}

/// A bus, tram or whatever leaving a specific stop at a specific time
public struct Departure {
    public let id: String
    public let line: String
    public let direction: String
    public let platform: Platform?
    public let mode: Mode
    public let realTime: Date?
    public let scheduledTime: Date
    public let state: State
    public let routeChanges: [String]?
    public let diva: Diva?

    public var actualEta: Int? {
        guard let realTime = realTime else { return nil }
        return Int(realTime.timeIntervalSince(Date()) / 60)
    }

    public var scheduledEta: Int {
        return Int(scheduledTime.timeIntervalSince(Date()) / 60)
    }

    public var fancyEta: String {
        guard let realTime = realTime else { return "\(scheduledEta)" }
        let diff = Int(realTime.timeIntervalSince(scheduledTime) / 60)

        if diff < 0 {
            return "\(scheduledEta)\(diff)"
        } else if diff == 0 {
            return "\(scheduledEta)"
        } else {
            return "\(scheduledEta)+\(diff)"
        }
    }
}

// Namespacing some sub-types
extension Departure {
    public enum State {
        case onTime
        case delayed
        case other(String) // TODO: Figure out what these are. "Cancelled" maybe? And others?
        case unknown

        init(_ string: String) {
            switch string {
            case "InTime": self = .onTime
            case "Delayed": self = .delayed
            default: self = .other(string)
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

extension MonitorResponse: Unmarshaling {
    public init(object: MarshaledObject) throws {
        self.stopName = try object <| "Name"
        self.place = try object <| "Place"
        self.expirationTime = try object <| "ExpirationTime"
        self.departures = try object <| "Departures"
    }
}

extension Departure: Unmarshaling {
    public init(object: MarshaledObject) throws {
        self.id = try object <| "Id"
        self.line = try object <| "LineName"
        self.direction = try object <| "Direction"
        self.mode = try object <| "Mot"

        self.scheduledTime = try object <| "ScheduledTime"
        self.routeChanges = try object <| "RouteChanges"
        self.platform = try object <| "Platform"
        self.diva = try object <| "Diva"
        self.realTime = try object <| "RealTime"

        let rawState: String? = try object <| "State"
        if let stateString = rawState {
            self.state = try Departure.State.value(from: stateString)
        } else {
            self.state = .unknown
        }
    }
}

extension Departure.State: ValueType {
    public static func value(from object: Any) throws -> Departure.State {
        guard let stateStr = object as? String else {
            throw MarshalError.typeMismatch(expected: String.self, actual: type(of: object))
        }
        return self.init(stateStr)
    }
}

// MARK: - API

extension Departure {
    public static func monitor(stopWithId id: String, date: Date = Date(), dateType: DateType = .arrival, allowedModes modes: [Mode] = Mode.all, allowShorttermChanges: Bool = true, completion: @escaping (Result<MonitorResponse>) -> Void) {
        let data: [String: Any] = [
            "stopid": id,
            "time": date.iso8601,
            "isarrival": dateType.requestVal,
            "limit": 0,
            "shorttermchanges": allowShorttermChanges,
            "mot": modes.map {$0.identifier}
        ]

        post(Endpoint.departureMonitor, data: data, completion: completion)
    }

    /// Convenience function taking a stop name. Sends of a find request first and uses the first result's `id` as an argument for the monitor request.
    public static func monitor(stopWithName name: String, date: Date = Date(), dateType: DateType = .arrival, allowedModes modes: [Mode] = Mode.all, allowShorttermChanges: Bool = true, completion: @escaping (Result<MonitorResponse>) -> Void) {
        Stop.find(name) { result in
            switch result {
            case .failure(let error): completion(Result(failure: error))
            case .success(let response):
                guard let first = response.stops.first else { completion(Result(failure: DVBError.response)); return }
                Departure.monitor(stopWithId: first.id, date: date, dateType: dateType, allowedModes: modes, allowShorttermChanges: allowShorttermChanges, completion: completion)
            }
        }
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
    case (.unknown, .unknown): return true
    default: return false
    }
}
