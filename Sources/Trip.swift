import Foundation
import Marshal

public struct TripsResponse {
    public let stops: [TripStop]
    public let expirationTime: Date
}

public struct TripStop {
    public enum Position: String {
        case Previous
        case Current
        case Next
    }

    public let id: String
    public let place: String
    public let name: String
    public let position: Position
    public let platform: Platform?
    public let time: Date
}

// MARK: - JSON

extension TripsResponse: Unmarshaling {
    public init(object: MarshaledObject) throws {
        self.stops = try object <| "Stops"
        self.expirationTime = try object <| "ExpirationTime"
    }
}

extension TripStop: Unmarshaling {
    public init(object: MarshaledObject) throws {
        self.id = try object <| "Id"
        self.place = try object <| "Place"
        self.name = try object <| "Name"
        self.position = try object <| "Position"
        self.platform = try object <| "Platform"
        self.time = try object <| "Time"
    }
}

// MARK: - API

extension TripStop {
    public static func get(forTripID tripID: String, stopID: String, atTime time: Date, completion: @escaping (Result<TripsResponse>) -> Void) {
        let data: [String: Any] = [
            "tripid": tripID,
            "stopid": stopID,
            "time": time.datestring
        ]

        post(Endpoint.trip, data: data, completion: completion)
    }
}
