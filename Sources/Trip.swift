import Foundation
import Marshal

public struct TripsResponse {
    public let stops: [TripStop]
    public let expirationTime: Date
}

public struct TripStop {
    public enum Position {
        case previous
        case current
        case next
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

extension TripStop.Position: ValueType {
    public static func value(from object: Any) throws -> TripStop.Position {
        guard let rawVal = object as? String else {
            throw MarshalError.typeMismatch(expected: String.self, actual: type(of: object))
        }
        switch rawVal.lowercased() {
        case "previous": return .previous
        case "current": return .current
        case "next": return .next
        default:
            throw MarshalError.typeMismatch(expected: "Valid Position String", actual: rawVal)
        }
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
