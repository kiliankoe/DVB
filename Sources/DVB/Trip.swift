import Foundation

public struct TripsResponse: Decodable {
    public let stops: [TripStop]
    public let expirationTime: Date

    private enum CodingKeys: String, CodingKey {
        case stops = "Stops"
        case expirationTime = "ExpirationTime"
    }
}

public struct TripStop: Decodable {
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

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.place = try container.decode(String.self, forKey: .place)
        self.name = try container.decode(String.self, forKey: .name)
        self.position = try container.decode(Position.self, forKey: .position)
        self.platform = try container.decodeIfPresent(Platform.self, forKey: .platform)
        let rawTime = try container.decode(String.self, forKey: .time)
        guard let time = Date(fromSAPPattern: rawTime) else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [CodingKeys.time], debugDescription: "Failed to read time."))
        }
        self.time = time
    }
}

extension TripStop {
    public enum Position: String, Decodable {
        // swiftlint:disable:next identifier_name
        case Previous, Current, Next
    }
}

// MARK: - API

extension TripStop {
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
