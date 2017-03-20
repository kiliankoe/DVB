import Foundation
import Marshal

public struct TripResponse {
    public let routes: [Trip]
    public let sessionId: String
}

public struct Trip {
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

extension Trip {
    public struct ModeElement {
        public let name: String
        public let mode: Mode?
        public let direction: String?
        public let changes: [String]?
        public let diva: Diva
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
        public let coordinate: Coordinate?
        public let mapPdfId: String?
    }

    public struct MapData {
        public let mode: String
        public let points: [Coordinate]
    }
}

// MARK: - JSON

extension TripResponse: Unmarshaling {
    public init(object: MarshaledObject) throws {
        self.sessionId = try object <| "SessionId"
        self.routes = try object <| "Routes"
    }
}

extension Trip: Unmarshaling {
    public init(object: MarshaledObject) throws {
        self.priceLevel = try object <| "PriceLevel"
        self.price = try object <| "Price"
        self.duration = try object <| "Duration"
        self.interchanges = try object <| "Interchanges"
        self.modeChain = try object <| "MotChain"
        self.fareZoneOrigin = try object <| "FareZoneOrigin"
        self.fareZoneDestination = try object <| "FareZoneDestination"
        self.mapPdfId = try object <| "MapPdfId"
        self.routeId = try object <| "RouteId"
        self.partialRoutes = try object <| "PartialRoutes"
        self.mapData = try object <| "MapData"
    }
}

extension Trip.ModeElement: Unmarshaling {
    public init(object: MarshaledObject) throws {
        self.name = try object <| "Name"
        self.diva = try object <| "Diva"

        let rawMode: String = try object <| "Type"
        if let mode = try? Mode.value(from: rawMode) {
            self.mode = mode
        } else {
            self.mode = nil // FIXME: This breaks on "Footpath" for example. Should this even be a `Mode`?
        }

        self.direction = try object <| "Direction"
        self.changes = try object <| "Changes"
    }
}

extension Trip.RoutePartial: Unmarshaling {
    public init(object: MarshaledObject) throws {
        self.mode = try object <| "Mot"
        self.mapDataIndex = try object <| "MapDataIndex"
        self.shift = try object <| "Shift"
        self.duration = try object <| "Duration"
        self.regularStops = try object <| "RegularStops"
        self.partialRouteId = try object <| "PartialRouteId"
    }
}

extension Trip.RouteStop: Unmarshaling {
    public init(object: MarshaledObject) throws {
        self.arrivalTime = try object <| "ArrivalTime"
        self.departureTime = try object <| "DepartureTime"
        self.place = try object <| "Place"
        self.name = try object <| "Name"
        self.type = try object <| "Type"
        self.dataId = try object <| "DataId"

        let latitude: Double = try object <| "Latitude"
        let longitude: Double = try object <| "Longitude"
        self.coordinate = Coordinate(x: latitude, y: longitude)

        self.platform = try object <| "Platform"
        self.mapPdfId = try object <| "MapPdfId"
    }
}

extension Trip.MapData: ValueType {
    public static func value(from object: Any) throws -> Trip.MapData {
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
        for i in 0..<gkCoords.count - 1 {
            coordTuples.append((gkCoords[i], gkCoords[i+1]))
        }

        let coords = coordTuples
            .map { Coordinate(x: $0.0, y: $0.1) }
            .flatMap { $0 }

        //        if let mode = Mode(rawValue: first.lowercased()) {
        //            self.mode = mode
        //        } else {
        //            self.mode = nil // FIXME: This is stupid. Gotta find a better way to store 'Footpath'
        //        }

        return self.init(mode: first, points: coords)
    }
}

// MARK: - API

extension Trip {
    public enum MobilityRestriction: String {
        case none = "None"
        // TODO: Pull the other cases for this from the app
    }
}

extension Trip {
    public static func find(fromWithID originId: String, toWithID destinationId: String, time: Date = Date(), dateIsArrival: Bool = false, allowShortTermChanges: Bool = true, mobilityRestriction: MobilityRestriction = .none, completion: @escaping (Result<TripResponse>) -> Void) {
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
                "mot": Mode.all.map { $0.identifier }
            ]
        ]

        post(Endpoint.trips, data: data, completion: completion)
    }

    /// Convenience function taking to stop names instead of IDs. Sends of two find requests first.
    public static func find(from origin: String, to destination: String, time: Date = Date(), dateIsArrival: Bool = false, allowShortTermChanges: Bool = true, mobilityRestriction: MobilityRestriction = .none, completion: @escaping (Result<TripResponse>) -> Void) {
        Stop.find(origin) { result in
            switch result {
            case .failure(let error): completion(Result(failure: error))
            case .success(let response):
                guard let originStop = response.stops.first else { completion(Result(failure: DVBError.response)); return }
                Stop.find(destination) { result in
                    switch result {
                    case .failure(let error): completion(Result(failure: error))
                    case .success(let response):
                        guard let destinationStop = response.stops.first else { completion(Result(failure: DVBError.response)); return }
                        Trip.find(fromWithID: originStop.id, toWithID: destinationStop.id, time: time, dateIsArrival: dateIsArrival, allowShortTermChanges: allowShortTermChanges, mobilityRestriction: mobilityRestriction, completion: completion)
                    }
                }
            }
        }
    }
}
