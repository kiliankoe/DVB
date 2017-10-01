import Foundation
import GaussKrueger

public struct POIResponse {
    public let pins: [POI]
    public let expirationTime: Date
}

public struct POI {
    public let descriptionString: String // FIXME: ‼️
}

extension POI {
    public enum Kind: String {
        // swiftlint:disable:next identifier_name
        case RentABike, Stop, Poi, CarSharing, TicketMachine, Platform, ParkAndRide

        public static var all: [Kind] {
            return [.RentABike, .Stop, .Poi, .CarSharing, .TicketMachine, .Platform, .ParkAndRide]
        }
    }
}

// MARK: - JSON

extension POIResponse: Unmarshaling {
    public init(object: MarshaledObject) throws {
        pins = try object <| "Pins"
        expirationTime = try object <| "ExpirationTime"
    }
}

extension POI: ValueType {
    public static func value(from object: Any) throws -> POI {
        guard let rawVal = object as? String else {
            throw MarshalError.typeMismatch(expected: String.self, actual: type(of: object))
        }

        return self.init(descriptionString: rawVal)
    }
}

// MARK: - API

extension POI {
    public struct CoordRect {
        public let northeast: Coordinate
        public let southwest: Coordinate
    }

    public static func find(types: [POI.Kind] = POI.Kind.all, in rect: CoordRect, session: URLSession = .shared, completion: @escaping (Result<POIResponse>) -> Void) {
        guard
            let gkSWCoord = rect.southwest.asGK,
            let gkNECoord = rect.northeast.asGK
        else {
            completion(Result(failure: DVBError.coordinate))
            return
        }

        let data: [String: Any] = [
            "swlat": gkSWCoord.x,
            "swlng": gkSWCoord.y,
            "nelat": gkNECoord.x,
            "nelng": gkNECoord.y,
            "showlines": true,
            "pintypes": types.map { $0.rawValue },
        ]

        post(Endpoint.poiSearch, data: data, session: session, completion: completion)
    }
}
