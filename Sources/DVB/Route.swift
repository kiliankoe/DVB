import Foundation
import Marshal
import gausskrueger

public struct RoutesResponse {
    public let routes: [Route]
    public let sessionId: String
}

public struct Route {
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
}

extension Route {
    public struct ModeElement {
        public let name: String?
        public let mode: Mode?
        public let direction: String?
        public let changes: [String]?
        public let diva: Diva?
    }

    public struct RoutePartial {
        public let partialRouteId: Int?
        public let duration: Int?
        public let mode: ModeElement
        public let mapDataIndex: Int
        public let shift: String
        public let regularStops: [RouteStop]?
    }

    public struct RouteStop {
        public let arrivalTime: Date
        public let departureTime: Date
        public let place: String
        public let name: String
        public let type: String
        public let dataId: String
        public let platform: Platform?
        public let coordinate: WGSCoordinate?
        public let mapPdfId: String?
    }

    public struct MapData {
        public let mode: String
        public let points: [WGSCoordinate]
    }
}

// MARK: - JSON

extension RoutesResponse: Unmarshaling {
    public init(object: MarshaledObject) throws {
        sessionId = try object <| "SessionId"
        routes = try object <| "Routes"
    }
}

extension Route: Unmarshaling {
    public init(object: MarshaledObject) throws {
        priceLevel = try object <| "PriceLevel"
        price = try object <| "Price"
        duration = try object <| "Duration"
        interchanges = try object <| "Interchanges"
        modeChain = try object <| "MotChain"
        fareZoneOrigin = try object <| "FareZoneOrigin"
        fareZoneDestination = try object <| "FareZoneDestination"
        mapPdfId = try object <| "MapPdfId"
        routeId = try object <| "RouteId"
        partialRoutes = try object <| "PartialRoutes"
        mapData = try object <| "MapData"
    }
}

extension Route.ModeElement: Unmarshaling {
    public init(object: MarshaledObject) throws {
        name = try object <| "Name"
        diva = try object <| "Diva"

        if let mode: Mode = try? object <| "Type" {
            self.mode = mode
        } else {
            mode = nil // FIXME: This breaks on "Footpath" for example. Should this even be a `Mode`?
        }

        direction = try object <| "Direction"
        changes = try object <| "Changes"
    }
}

extension Route.RoutePartial: Unmarshaling {
    public init(object: MarshaledObject) throws {
        mode = try object <| "Mot"
        mapDataIndex = try object <| "MapDataIndex"
        shift = try object <| "Shift"
        duration = try object <| "Duration"
        regularStops = try object <| "RegularStops"
        partialRouteId = try object <| "PartialRouteId"
    }
}

extension Route.RouteStop: Unmarshaling {
    public init(object: MarshaledObject) throws {
        arrivalTime = try object <| "ArrivalTime"
        departureTime = try object <| "DepartureTime"
        place = try object <| "Place"
        name = try object <| "Name"
        type = try object <| "Type"
        dataId = try object <| "DataId"

        let latitude: Double = try object <| "Latitude"
        let longitude: Double = try object <| "Longitude"
        coordinate = GKCoordinate(x: latitude, y: longitude).asWGS

        platform = try object <| "Platform"
        mapPdfId = try object <| "MapPdfId"
    }
}

extension Route.MapData: ValueType {
    public static func value(from object: Any) throws -> Route.MapData {
        guard let string = object as? String else {
            throw MarshalError.typeMismatch(expected: String.self, actual: type(of: object))
        }

        let components = string.components(separatedBy: "|")
        guard components.count % 2 == 0 else {
            throw DVBError.decode // FIXME: Use better error type
        }

        guard let first = components.first else {
            throw DVBError.decode // FIXME: Use better error type
        }

        let gkCoords = components
            .dropFirst() // transportmode
            .dropLast() // empty value
            .map { Double($0) }
            .flatMap { $0 }

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

        //        if let mode = Mode(rawValue: first.lowercased()) {
        //            self.mode = mode
        //        } else {
        //            self.mode = nil // FIXME: This is stupid. Gotta find a better way to store 'Footpath'
        //        }

        return self.init(mode: first, points: coords)
    }
}

// MARK: - API

extension Route {
    public enum MobilityRestriction: String {
        case none = "None"
        // TODO: Pull the other cases for this from the app
    }
}

extension Route {
    public static func find(fromWithID originId: String, toWithID destinationId: String, time: Date = Date(), dateIsArrival: Bool = false, allowShortTermChanges: Bool = true, mobilityRestriction: MobilityRestriction = .none, session: URLSession = .shared, completion: @escaping (Result<RoutesResponse>) -> Void) {
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
    public static func find(from origin: String, to destination: String, time: Date = Date(), dateIsArrival: Bool = false, allowShortTermChanges: Bool = true, mobilityRestriction: MobilityRestriction = .none, session: URLSession = .shared, completion: @escaping (Result<RoutesResponse>) -> Void) {
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
