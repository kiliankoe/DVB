import Foundation

public struct POI {
    public let descriptionString: String // FIXME:
}

extension POI: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.descriptionString = try container.decode(String.self)
    }
}

extension POI: Equatable {}

extension POI: Hashable {}

// MARK: - API

extension POI {
    public struct CoordRect {
        public let northeast: Coordinate
        public let southwest: Coordinate

        public init(northeast: Coordinate, southwest: Coordinate) {
            self.northeast = northeast
            self.southwest = southwest
        }
    }

    public static func find(types: [POI.Kind] = POI.Kind.allCases,
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
