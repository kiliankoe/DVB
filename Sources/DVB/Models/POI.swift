import Foundation

public struct POIResponse: Decodable, Equatable {
    public let pins: [POI]
    public let expirationTime: Date

    private enum CodingKeys: String, CodingKey {
        case pins = "Pins"
        case expirationTime = "ExpirationTime"
    }
}

public struct POI: Decodable, Equatable, Hashable {
    public let descriptionString: String // FIXME: ‼️

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.descriptionString = try container.decode(String.self)
    }
}

extension POI {
    public enum Kind: String, Equatable, Hashable {
        case rentABike = "RentABike"
        case stop = "Stop"
        case poi = "Poi"
        case carSharing = "CarSharing"
        case ticketMachine = "TicketMachine"
        case platform = "Platform"
        case parkAndRide = "ParkAndRide"

        public static var all: [Kind] {
            return [.rentABike, .stop, .poi, .carSharing, .ticketMachine, .platform, .parkAndRide]
        }
    }
}

// MARK: - API

extension POI {
    public struct CoordRect {
        public let northeast: Coordinate
        public let southwest: Coordinate
    }

    public static func find(types: [POI.Kind] = POI.Kind.all,
                            in rect: CoordRect,
                            session: URLSession = .shared,
                            completion: @escaping (Result<POIResponse>) -> Void) {
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
