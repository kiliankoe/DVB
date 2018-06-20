import Foundation

/// A place where a bus, tram or whatever can stop.
public struct Stop {
    public let id: String
    public let name: String
    public let region: String?
    public let location: WGSCoordinate?

    public init(id: String, name: String, region: String?, location: Coordinate?) {
        self.id = id
        self.name = name
        self.region = region
        self.location = location?.asWGS
    }
}

extension Stop: Equatable {}

extension Stop: Hashable {}

extension Stop: Decodable {
    public init(from responseString: String) throws {
        let components = responseString.components(separatedBy: "|")
        guard components.count == 9 else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(codingPath: [],
                                      debugDescription: "Illegal number of parameters for a Stop."))
        }
        self.id = components[0]
        self.region = components[2].isEmpty ? nil : components[2]
        self.name = components[3]

        // swiftlint:disable identifier_name
        guard
            let x = Double(components[5]),
            let y = Double(components[4])
        else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(codingPath: [],
                                      debugDescription: "Stop coordinates should be numeric values."))
        }
        // swiftlint:enable identifier_name

        if x != 0, y != 0 {
            self.location = GKCoordinate(x: x, y: y).asWGS
        } else {
            self.location = nil
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        self = try Stop(from: string)
    }
}

// MARK: - API

extension Stop {
    /// Get a list of stops matching a given query.
    ///
    /// - Parameters:
    ///   - query: search query
    ///   - session: URL session, defaults to `.shared`
    ///   - completion: handler
    public static func find(_ query: String,
                            session: URLSession = .shared,
                            completion: @escaping (Result<FindResponse>) -> Void) {
        let data: [String: Any] = [
            "limit": 0,
            "query": query,
            "stopsOnly": true,
            "dvb": true,
        ]
        post(Endpoint.pointfinder, data: data, session: session, completion: completion)
    }

    public static func findNear(lat: Double,
                                lng: Double,
                                session: URLSession = .shared,
                                completion: @escaping (Result<FindResponse>) -> Void) {
        let coord = WGSCoordinate(latitude: lat, longitude: lng)
        findNear(coord: coord, session: session, completion: completion)
    }

    /// Get a list of stops near a given coordinate.
    ///
    /// - Warning: The first result is a reverse-geocoded address and not a stop.
    ///
    /// - Parameters:
    ///   - coord: coordinate
    ///   - session: URL session, defaults to `.shared`
    ///   - completion: handler
    public static func findNear(coord: Coordinate,
                                session: URLSession = .shared,
                                completion: @escaping (Result<FindResponse>) -> Void) {
        // swiftlint:disable:next identifier_name
        guard let gk = coord.asGK else {
            completion(Result(failure: DVBError.coordinate))
            return
        }
        let data: [String: Any] = [
            "limit": 0,
            "assignedStops": true,
            "query": "coord:\(Int(gk.x)):\(Int(gk.y))",
        ]
        post(Endpoint.pointfinder, data: data, session: session, completion: completion)
    }
}

extension Stop {
    public func monitor(date: Date = Date(),
                        dateType: Departure.DateType = .arrival,
                        allowedModes modes: [Mode] = Mode.allRequest,
                        allowShorttermChanges: Bool = true,
                        session: URLSession = .shared,
                        completion: @escaping (Result<MonitorResponse>) -> Void) {
        Departure.monitor(stopWithId: self.id,
                          date: date,
                          dateType: dateType,
                          allowedModes: modes,
                          allowShorttermChanges: allowShorttermChanges,
                          session: session,
                          completion: completion)
    }
}

// MARK: - Utility

extension Stop: CustomStringConvertible {
    public var description: String {
        if let region = region, !region.isEmpty {
            return "\(name), \(region)"
        }
        return name
    }
}
