import Foundation

/// A bus, tram or whatever leaving a specific stop at a specific time
public struct Departure {
    public let id: String
    public let line: String
    public let direction: String
    public let platform: Platform?
    public let mode: Mode
    public let realTime: Date?
    public let scheduledTime: Date
    public let state: State?
    public let routeChanges: [String]?
    public let diva: Diva?

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
    public func localizedETA(for locale: Locale = .current) -> String {
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

extension Departure: Decodable {
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
}

extension Departure: Equatable {}

extension Departure: Hashable {}

// MARK: - API

extension Departure {
    public enum DateType {
        case arrival
        case departure

        var requestVal: Bool {
            return self == .arrival
        }
    }

    public static func monitor(stopWithId id: String,
                               date: Date = Date(),
                               dateType: DateType = .arrival,
                               allowedModes modes: [Mode] = Mode.allRequest,
                               allowShorttermChanges: Bool = true,
                               session: URLSession = .shared,
                               completion: @escaping (Result<MonitorResponse>) -> Void) {
        let data: [String: Any] = [
            "stopid": id,
            "time": date.iso8601,
            "isarrival": dateType.requestVal,
            "limit": 0,
            "shorttermchanges": allowShorttermChanges,
            "mot": modes.map { $0.rawValue },
        ]

        post(Endpoint.departureMonitor, data: data, session: session, completion: completion)
    }

    /// Convenience function taking a stop name. Sends of a find request first and uses the first
    /// result's `id` as an argument for the monitor request.
    public static func monitor(stopWithName name: String,
                               date: Date = Date(),
                               dateType: DateType = .arrival,
                               allowedModes modes: [Mode] = Mode.allRequest,
                               allowShorttermChanges: Bool = true,
                               session: URLSession = .shared,
                               completion: @escaping (Result<MonitorResponse>) -> Void) {
        Stop.find(name, session: session) { result in
            switch result {
            case let .failure(error): completion(Result(failure: error))
            case let .success(response):
                guard let first = response.stops.first else {
                    completion(Result(failure: DVBError.response))
                    return
                }
                Departure.monitor(stopWithId: first.id,
                                  date: date,
                                  dateType: dateType,
                                  allowedModes: modes,
                                  allowShorttermChanges: allowShorttermChanges,
                                  session: session,
                                  completion: completion)
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
