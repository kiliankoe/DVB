import Foundation
import GaussKrueger

public struct RoutesResponse: Decodable {
    public let routes: [Route]
    public let sessionId: String

    private enum CodingKeys: String, CodingKey {
        case routes = "Routes"
        case sessionId = "SessionId"
    }
}

public struct Route: Decodable {
    public let priceLevel: Int?
    public let price: String?
    public let duration: Int
    public let interchanges: Int
    public let modeChain: [ModeElement]
    public let fareZoneOrigin: Int?
    public let fareZoneDestination: Int?
    public let mapPdfId: String
    public let routeId: Int
    public let partialRoutes: [RoutePartial]
    public let mapData: [MapData]

    private enum CodingKeys: String, CodingKey {
        case priceLevel = "PriceLevel"
        case price = "Price"
        case duration = "Duration"
        case interchanges = "Interchanges"
        case modeChain = "MotChain"
        case fareZoneOrigin = "FareZoneOrigin"
        case fareZoneDestination = "FareZoneDestination"
        case mapPdfId = "MapPdfId"
        case routeId = "RouteId"
        case partialRoutes = "PartialRoutes"
        case mapData = "MapData"
    }
}

extension Route {
    public struct ModeElement: Decodable {
        public let name: String?
        public let mode: Mode?
        public let direction: String?
        public let changes: [String]?
        public let diva: Diva?

        //swiftlint:disable:next nesting
        private enum CodingKeys: String, CodingKey {
            case name = "Name"
            case mode = "Type"
            case direction = "Direction"
            case changes = "Changes"
            case diva = "Diva"
        }
    }

    public struct RoutePartial: Decodable {
        public let partialRouteId: Int?
        public let duration: Int?
        public let mode: ModeElement
        public let mapDataIndex: Int
        public let shift: String
        public let regularStops: [RouteStop]?

        //swiftlint:disable:next nesting
        private enum CodingKeys: String, CodingKey {
            case partialRouteId = "PartialRouteId"
            case duration = "Duration"
            case mode = "Mot"
            case mapDataIndex = "MapDataIndex"
            case shift = "Shift"
            case regularStops = "RegularStops"
        }
    }

    public struct RouteStop: Decodable {
        public let arrivalTime: Date
        public let departureTime: Date
        public let place: String
        public let name: String
        public let type: String
        public let dataId: String
        public let platform: Platform?
        public let coordinate: WGSCoordinate?
        public let mapPdfId: String?

        //swiftlint:disable:next nesting
        private enum CodingKeys: String, CodingKey {
            case arrivalTime = "ArrivalTime"
            case departureTime = "DepartureTime"
            case place = "Place"
            case name = "Name"
            case type = "Type"
            case dataId = "DataId"
            case platform = "Platform"
            case latitude = "Latitude"
            case longitude = "Longitude"
            case mapPdfId = "MapPdfId"
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.arrivalTime = try container.decode(Date.self, forKey: .arrivalTime)
            self.departureTime = try container.decode(Date.self, forKey: .departureTime)
            self.place = try container.decode(String.self, forKey: .place)
            self.name = try container.decode(String.self, forKey: .name)
            self.type = try container.decode(String.self, forKey: .type)
            self.dataId = try container.decode(String.self, forKey: .dataId)
            self.platform = try container.decodeIfPresent(Platform.self, forKey: .platform)
            let lat = try container.decode(Double.self, forKey: .latitude)
            let lng = try container.decode(Double.self, forKey: .longitude)
            self.coordinate = GKCoordinate(x: lat, y: lng).asWGS
            self.mapPdfId = try container.decodeIfPresent(String.self, forKey: .mapPdfId)
        }
    }

    public struct MapData: Decodable {
        public let mode: String
        public let points: [WGSCoordinate]

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let string = try container.decode(String.self)

            let components = string.components(separatedBy: "|")
            guard components.count % 2 == 0 else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "MapData expects an even number of coordinates incl. a mode at the beginning and an empty value at the end.")
            }

            guard let mode = components.first else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Expected to find mode identifier as the first value.")
            }

            let gkCoords = components
                .dropFirst() // transportmode
                .dropLast() // empty value
                .flatMap { Double($0) }

            guard gkCoords.count % 2 == 0 else {
                throw DVBError.decode
            }

            // I'd love an implementation of `chunk` in the stdlib...
            var coordTuples = [(Double, Double)]()
            for i in 0 ..< gkCoords.count - 1 {
                coordTuples.append((gkCoords[i], gkCoords[i + 1]))
            }

            let coords = coordTuples
                .flatMap { GKCoordinate(x: $0.0, y: $0.1).asWGS }

            self.mode = mode
            self.points = coords
        }
    }
}

// MARK: - API

extension Route {
    public struct MobilityRestriction {
        let rawValue: String

        public static let None = MobilityRestriction(rawValue: "None")
        // TODO: Pull the other cases for this from the app

        public init(rawValue: String) {
            self.rawValue = rawValue
        }
    }
}

extension Route {
    public static func find(fromWithID originId: String,
                            toWithID destinationId: String,
                            time: Date = Date(),
                            dateIsArrival: Bool = false,
                            allowShortTermChanges: Bool = true,
                            mobilityRestriction: MobilityRestriction = .None,
                            session: URLSession = .shared,
                            completion: @escaping (Result<RoutesResponse>) -> Void) {
        let data: [String: Any] = [
            "origin": originId,
            "destination": destinationId,
            "time": time.iso8601,
            "isarrivaltime": dateIsArrival,
            "shorttermchanges": allowShortTermChanges,
            "mobilitySettings": mobilityRestriction.rawValue,
            "includeAlternativeStops": true,
            "standardSettings": [
                "maxChanges": "Unlimited",
                "walkingSpeed": "Normal",
                "footpathToStop": 5,
                "mot": Mode.all.map { $0.identifier },
            ],
        ]

        post(Endpoint.route, data: data, session: session, completion: completion)
    }

    /// Convenience function taking to stop names instead of IDs. Sends of two find requests first.
    public static func find(from origin: String,
                            to destination: String,
                            time: Date = Date(),
                            dateIsArrival: Bool = false,
                            allowShortTermChanges: Bool = true,
                            mobilityRestriction: MobilityRestriction = .None,
                            session: URLSession = .shared,
                            completion: @escaping (Result<RoutesResponse>) -> Void) {
        Stop.find(origin, session: session) { result in
            switch result {
            case let .failure(error): completion(Result(failure: error))
            case let .success(response):
                guard let originStop = response.stops.first else { completion(Result(failure: DVBError.response)); return }
                Stop.find(destination, session: session) { result in
                    switch result {
                    case let .failure(error): completion(Result(failure: error))
                    case let .success(response):
                        guard let destinationStop = response.stops.first else { completion(Result(failure: DVBError.response)); return }
                        Route.find(fromWithID: originStop.id, toWithID: destinationStop.id, time: time, dateIsArrival: dateIsArrival, allowShortTermChanges: allowShortTermChanges, mobilityRestriction: mobilityRestriction, session: session, completion: completion)
                    }
                }
            }
        }
    }
}
