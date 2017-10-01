import Foundation

public struct MonitorResponse: Decodable {
    public let stopName: String
    public let place: String
    public let expirationTime: Date
    public let departures: [Departure]

    private enum CodingKeys: String, CodingKey {
        case stopName = "Name"
        case place = "Place"
        case expirationTime = "ExpirationTime"
        case departures = "Departures"
    }
}

/// A bus, tram or whatever leaving a specific stop at a specific time
public struct Departure: Decodable {
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

    private enum CodingKeys: String, CodingKey {
        case id = "Id"
        case line = "LineName"
        case direction = "Direction"
        case mode = "Mot"
        case scheduledTime = "ScheduledTime"
        case routeChanges = "RouteChanges"
        case platform = "Platform"
        case diva = "Diva"
        case realTime = "RealTime"
        case state = "State"
    }

    /// The actual ETA. Should only be different from the scheduled ETA if not on time.
    public var ETA: Int {
        guard let realTime = realTime else { return scheduledETA }
        return Int(realTime.timeIntervalSince(Date()) / 60)
    }

    /// The scheduled ETA, differs from actualEta if not on time.
    public var scheduledETA: Int {
        return Int(scheduledTime.timeIntervalSince(Date()) / 60)
    }

    /// ETA value including any possible delay.
    public var fancyETA: String {
        guard let realTime = realTime else { return "\(scheduledETA)" }
        let diff = Int(realTime.timeIntervalSince(scheduledTime) / 60)

        if diff < 0 {
            return "\(scheduledETA)\(diff)"
        } else if diff == 0 {
            return "\(scheduledETA)"
        } else {
            return "\(scheduledETA)+\(diff)"
        }
    }

    /// ETA as a localized description, e.g. "now" or "5 minutes".
    /// Supports German and English. Defaults to English for everything else.
    ///
    /// - Parameter locale: locale to use for localization, defaults to `Locale.current`
    /// - Returns: localized string
    public func localizedETA(for locale: Locale = Locale.current) -> String {
        switch locale.languageCode?.lowercased() {
        case .some("de"):
            switch self.ETA {
            case 0:
                return "jetzt"
            case 1:
                return "1 Minute"
            default:
                return "\(self.ETA) Minuten"
            }
        default:
            switch self.ETA {
            case 0:
                return "now"
            case 1:
                return "1 minute"
            default:
                return "\(self.ETA) minutes"
            }
        }
    }
}

// Namespacing some sub-types
extension Departure {
    public struct State: Decodable {
        public let rawValue: String

        public static let onTime = State(rawValue: "InTime")
        public static let delayed = State(rawValue: "Delayed")

        init(value: String) {
            switch value {
            case State.onTime.rawValue: self = State.onTime
            case State.delayed.rawValue: self = State.delayed
            default:
                self.rawValue = value
            }
        }

        init(rawValue: String) {
            self.rawValue = rawValue
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            self.init(value: try container.decode(String.self))
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

// MARK: - API

extension Departure {
    public static func monitor(stopWithId id: String,
                               date: Date = Date(),
                               dateType: DateType = .arrival,
                               allowedModes modes: [Mode] = Mode.all,
                               allowShorttermChanges: Bool = true,
                               session: URLSession = .shared,
                               completion: @escaping (Result<MonitorResponse>) -> Void) {
        let data: [String: Any] = [
            "stopid": id,
            "time": date.iso8601,
            "isarrival": dateType.requestVal,
            "limit": 0,
            "shorttermchanges": allowShorttermChanges,
            "mot": modes.map { $0.identifier },
        ]

        post(Endpoint.departureMonitor, data: data, session: session, completion: completion)
    }

    /// Convenience function taking a stop name. Sends of a find request first and uses the first result's `id` as an argument for the monitor request.
    public static func monitor(stopWithName name: String,
                               date: Date = Date(),
                               dateType: DateType = .arrival,
                               allowedModes modes: [Mode] = Mode.all,
                               allowShorttermChanges: Bool = true,
                               session: URLSession = .shared,
                               completion: @escaping (Result<MonitorResponse>) -> Void) {
        Stop.find(name, session: session) { result in
            switch result {
            case let .failure(error): completion(Result(failure: error))
            case let .success(response):
                guard let first = response.stops.first else { completion(Result(failure: DVBError.response)); return }
                Departure.monitor(stopWithId: first.id, date: date, dateType: dateType, allowedModes: modes, allowShorttermChanges: allowShorttermChanges, session: session, completion: completion)
            }
        }
    }
}

// MARK: - Utility

extension Departure: CustomStringConvertible {
    public var description: String {
        return "\(line) \(direction) departing in \(fancyETA) minutes."
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
