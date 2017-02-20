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
    public let realTime: Date?
    public let scheduledTime: Date
    public let state: State
    public let routeChanges: [String]?
    public let diva: Diva

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
    public struct Platform {
        public let name: String
        public let type: String
    }

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

extension MonitorResponse: FromJSON {
    init(json: JSON) throws {
        guard let stopName = json["Name"] as? String,
            let place = json["Place"] as? String,
            let expirationStr = json["ExpirationTime"] as? String,
            let expirationDate = Date(from: expirationStr),
            let departures = json["Departures"] as? [JSON] else {
                throw DVBError.decode
        }

        self.stopName = stopName
        self.place = place
        self.expirationDate = expirationDate
        self.departures = try departures.map { try Departure(json: $0) } // Why is the first try necessary here? o.O
    }
}

extension Departure: FromJSON {
    init(json: JSON) throws {
        guard let id = json["Id"] as? String,
            let line = json["LineName"] as? String,
            let direction = json["Direction"] as? String,
            let platformJson = json["Platform"],
            let modeStr = json["Mot"] as? String, let mode = Mode(rawValue: modeStr.lowercased()),
            let scheduledTimeStr = json["ScheduledTime"] as? String, let scheduledTime = Date(from: scheduledTimeStr),
            let divaStr = json["Diva"] else {
                throw DVBError.decode
        }

        let platform = try Platform(anyJSON: platformJson)
        let diva = try Diva(anyJSON: divaStr)

        self.id = id
        self.line = line
        self.direction = direction
        self.platform = platform
        self.mode = mode
        self.scheduledTime = scheduledTime
        self.routeChanges = json["RouteChanges"] as? [String]
        self.diva = diva

        if let realTimeStr = json["RealTime"] as? String,
            let realTime = Date(from: realTimeStr) {
                self.realTime = realTime
        } else {
            self.realTime = nil
        }

        if let stateStr = json["State"] as? String {
            self.state = State(stateStr)
        } else {
            self.state = .unknown
        }
    }
}

extension Departure.Platform: FromJSON {
    init(json: JSON) throws {
        guard let name = json["Name"] as? String,
            let type = json["Type"] as? String else {
                throw DVBError.decode
        }
        self.name = name
        self.type = type
    }
}

// MARK: - API

extension Departure {
    public static func monitor(id: String, date: Date = Date(), dateType: DateType = .arrival, allowedModes modes: [Mode] = Mode.all, allowShorttermChanges: Bool = true, completion: @escaping (Result<MonitorResponse>) -> Void) {
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
