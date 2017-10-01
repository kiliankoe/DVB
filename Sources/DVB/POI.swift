import Foundation
import GaussKrueger

public struct POIResponse: Decodable {
    public let pins: [POI]
    public let expirationTime: Date

    private enum CodingKeys: String, CodingKey {
        case pins = "Pins"
        case expirationTime = "ExpirationTime"
    }
}

public struct POI: Decodable {
    public let descriptionString: String // FIXME: ‼️

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.descriptionString = try container.decode(String.self)
    }
}

extension POI {
    public struct Kind {
        public let rawValue: String

        public let RentABike = Kind(rawValue: "RentABike")
        public let Stop = Kind(rawValue: "Stop")
        public let Poi = Kind(rawValue: "Poi")
        public let CarSharing = Kind(rawValue: "CarSharing")
        public let TicketMachine = Kind(rawValue: "TicketMachine")
        public let Platform = Kind(rawValue: "Platform")
        public let ParkAndRide = Kind(rawValue: "ParkAndRide")

        public static var all: [Kind] {
            return [.RentABike, .Stop, .Poi, .CarSharing, .TicketMachine, .Platform, .ParkAndRide]
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
