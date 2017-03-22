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
        stops = try object <| "Stops"
        expirationTime = try object <| "ExpirationTime"
    }
}

extension TripStop: Unmarshaling {
    public init(object: MarshaledObject) throws {
        id = try object <| "Id"
        place = try object <| "Place"
        name = try object <| "Name"
        position = try object <| "Position"
        platform = try object <| "Platform"
        time = try object <| "Time"
    }
}

// MARK: - API

extension TripStop {
    public static func get(forTripID tripID: String, stopID: String, atTime time: Date, completion: @escaping (Result<TripsResponse>) -> Void) {
        let data: [String: Any] = [
            "tripid": tripID,
            "stopid": stopID,
            "time": time.datestring,
        ]

        post(Endpoint.trip, data: data, completion: completion)
    }
}
