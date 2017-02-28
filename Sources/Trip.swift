import Foundation

public struct TripResponse {
    public let routes: [Trip]
    public let sessionId: String
}

public struct Trip {
    public let priceLevel: Int
    public let price: String
    public let duration: Int
    public let interchanges: Int
    public let modeChain: [ModeElement]
    public let fareZoneOrigin: Int
    public let fareZoneDestination: Int
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

extension TripResponse: FromJSON {
    init(json: JSON) throws {
        guard
            let sessionId = json["SessionId"] as? String,
            let routes = json["Routes"] as? [JSON]
        else {
            throw DVBError.decode
        }

        self.sessionId = sessionId
        self.routes = try routes.map { try Trip(json: $0) }
    }
}

extension Trip: FromJSON {
    init(json: JSON) throws {
        guard
            let priceLevel = json["PriceLevel"] as? Int,
            let price = json["Price"] as? String,
            let duration = json["Duration"] as? Int,
            let interchanges = json["Interchanges"] as? Int,
            let modeChain = json["MotChain"] as? [JSON],
            let fareZoneOrigin = json["FareZoneOrigin"] as? Int,
            let fareZoneDestination = json["FareZoneDestination"] as? Int,
            let mapPdfId = json["MapPdfId"] as? String,
            let routeId = json["RouteId"] as? Int,
            let partialRoutes = json["PartialRoutes"] as? [JSON],
            let mapDataStrs = json["MapData"] as? [String]
        else {
            throw DVBError.decode
        }

        self.priceLevel = priceLevel
        self.price = price
        self.duration = duration
        self.interchanges = interchanges
        self.modeChain = try modeChain.map { try ModeElement(json: $0) }
        self.fareZoneOrigin = fareZoneOrigin
        self.fareZoneDestination = fareZoneDestination
        self.mapPdfId = mapPdfId
        self.routeId = routeId
        self.partialRoutes = try partialRoutes.map { try RoutePartial(json: $0) }
        self.mapData = try mapDataStrs.map { try MapData(string: $0) }
    }
}

extension Trip.ModeElement: FromJSON {
    init(json: JSON) throws {
        guard
            let name = json["Name"] as? String,
            let diva = json["Diva"] as? JSON
        else {
            throw DVBError.decode
        }

        self.name = name
        self.diva = try Diva(json: diva)

        if let modeStr = json["Type"] as? String, let mode = Mode(rawValue: modeStr.lowercased()) {
            self.mode = mode
        } else {
            self.mode = nil
        }

        if let direction = json["Direction"] as? String {
            self.direction = direction
        } else {
            self.direction = nil
        }

        if let changes = json["Changes"] as? [String] {
            self.changes = changes
        } else {
            self.changes = nil
        }
    }
}

extension Trip.RoutePartial: FromJSON {
    init(json: JSON) throws {
        guard
            let mode = json["Mot"] as? JSON,
            let mapDataIndex = json["MapDataIndex"] as? Int,
            let shift = json["Shift"] as? String
        else {
            throw DVBError.decode
        }

        self.mode = try Trip.ModeElement(json: mode)
        self.mapDataIndex = mapDataIndex
        self.shift = shift

        if let duration = json["Duration"] as? Int {
            self.duration = duration
        } else {
            self.duration = nil
        }

        if let regularStops = json["RegularStops"] as? [JSON] {
            self.regularStops = try regularStops.map { try Trip.RouteStop(json: $0) }
        } else {
            self.regularStops = nil
        }

        if let partialRouteId = json["PartialRouteId"] as? Int {
            self.partialRouteId = partialRouteId
        } else {
            self.partialRouteId = nil
        }
    }
}

extension Trip.RouteStop: FromJSON {
    init(json: JSON) throws {
        guard
            let arrivalTimeStr = json["ArrivalTime"] as? String,
            let arrivalTime = Date(from: arrivalTimeStr),
            let departureTimeStr = json["DepartureTime"] as? String,
            let departureTime = Date(from: departureTimeStr),
            let place = json["Place"] as? String,
            let name = json["Name"] as? String,
            let type = json["Type"] as? String,
            let dataId = json["DataId"] as? String,
            let latitude = json["Latitude"] as? Int,
            let longitude = json["Longitude"] as? Int
        else {
            throw DVBError.decode
        }

        self.arrivalTime = arrivalTime
        self.departureTime = departureTime
        self.place = place
        self.name = name
        self.type = type
        self.dataId = dataId
        self.coordinate = Coordinate(x: Double(latitude), y: Double(longitude))

        if let platform = json["Platform"] as? JSON {
            self.platform = try Platform(json: platform)
        } else {
            self.platform = nil
        }

        if let mapPdfId = json["MapPdfId"] as? String {
            self.mapPdfId = mapPdfId
        } else {
            self.mapPdfId = nil
        }
    }
}

extension Trip.MapData {
    init(string: String) throws {
        let components = string.components(separatedBy: "|")
        guard components.count % 2 == 0 else {
            throw DVBError.decode
        }

        guard let first = components.first else {
            throw DVBError.decode
        }

        self.mode = first
//        if let mode = Mode(rawValue: first.lowercased()) {
//            self.mode = mode
//        } else {
//            self.mode = nil // FIXME: This is stupid. Gotta find a better way to store 'Footpath'
//        }

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

        self.points = coords
    }
}

// MARK: - API

extension Trip {
    public enum MobilityRestriction: String {
        case none = "None"
    }
}

extension Trip {
    public static func find(originId: String, destinationId: String, time: Date = Date(), dateIsArrival: Bool = false, allowShortTermChanges: Bool = true, mobilityRestriction: MobilityRestriction = .none, completion: @escaping (Result<TripResponse>) -> Void) {
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
}
