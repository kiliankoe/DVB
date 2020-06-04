import Foundation

public struct TripsResponse: Decodable, Equatable {
    public let stops: [TripStop]

    private enum CodingKeys: String, CodingKey {
        case stops = "Stops"
    }
}

public struct TripStop: Decodable, Equatable {
    public let id: String
    public let place: String
    public let name: String
    public let position: Position
    public let platform: Platform?
    public let time: Date

    private enum CodingKeys: String, CodingKey {
        case id = "Id"
        case place = "Place"
        case name = "Name"
        case position = "Position"
        case platform = "Platform"
        case time = "Time"
    }
}

extension TripStop {
    public enum Position: String, Decodable {
        case previous = "Previous"
        case current = "Current"
        case next = "Next"
    }
}

// MARK: - API

extension TripStop: Hashable {
    public static func get(forTripID tripID: String,
                           stopID: String,
                           atTime time: Date,
                           session: URLSession = .shared,
                           completion: @escaping (Result<TripsResponse>) -> Void) {
        let data: [String: Any] = [
            "tripid": tripID,
            "stopid": stopID,
            "time": time.sapPattern,
        ]

        post(Endpoint.trip, data: data, session: session, completion: completion)
    }
}
