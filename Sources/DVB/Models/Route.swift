import Foundation

public struct RoutesResponse: Decodable {
    public let routes: [Route]
    public let sessionId: String

    private enum CodingKeys: String, CodingKey {
        case routes = "Routes"
        case sessionId = "SessionId"
    }
}

public struct Route: Decodable, Equatable {
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
    public struct ModeElement: Decodable, Equatable {
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

    public struct RoutePartial: Decodable, Equatable {
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

    public struct RouteStop: Decodable, Equatable {
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

    public struct MapData: Decodable, Equatable {
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
                .compactMap { Double($0) }

            guard gkCoords.count % 2 == 0 else {
                throw DVBError.decode
            }

            // I'd love an implementation of `chunk` in the stdlib...
            var coordTuples = [(Double, Double)]()
            // swiftlint:disable:next identifier_name
            for i in 0 ..< gkCoords.count - 1 {
                coordTuples.append((gkCoords[i], gkCoords[i + 1]))
            }

            let coords = coordTuples
                .compactMap { GKCoordinate(x: $0.0, y: $0.1).asWGS }

            self.mode = mode
            self.points = coords
        }
    }
}

extension Route.RouteStop: Hashable {
    public var hashValue: Int {
        return self.name.hashValue ^ self.place.hashValue ^ self.arrivalTime.hashValue ^ self.departureTime.hashValue ^ self.dataId.hashValue
    }
}

// MARK: - API

extension Route {
    public enum MobilitySettings: Encodable {
        //swiftlint:disable:next nesting
        public enum PreconfiguredMobilitySettings: String, Encodable {
            case none = "None"
            case medium = "Medium"
            case high = "High"
        }

        //swiftlint:disable:next nesting
        public struct IndividualMobilitySettings: Encodable {
            //swiftlint:disable:next nesting
            public enum EntranceOption: String, Encodable {
                case any = "Any"
                case small = "Small"
                case noStep = "NoStep"
            }

            public let noSolidStairs: Bool
            public let noEscalators: Bool
            public let minimumInterchangeCount: Bool
            public let entranceOption: EntranceOption

            //swiftlint:disable:next nesting
            private enum CodingKeys: String, CodingKey {
                case noSolidStairs = "solidStairs"
                case noEscalators = "escalators"
                case minimumInterchangeCount = "leastChange"
                case entranceOption = "entrance"
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case ._preconfigured(let preconfiguredRestriction):
                try container.encode(preconfiguredRestriction)
            case ._individual(let individualRestriction):
                try container.encode(individualRestriction)
            }
        }

        /// Please use `.none`, `.medium` or `.high` instead of this.
        case _preconfigured(PreconfiguredMobilitySettings) // swiftlint:disable:this identifier_name
        /// Please use `.individual(...:)` instead of this.
        case _individual(IndividualMobilitySettings) // swiftlint:disable:this identifier_name

        /// "Ohne Einschränkungen"
        public static let none = MobilitySettings._preconfigured(.none)
        /// "Rollator, Kinderwagen"
        public static let medium = MobilitySettings._preconfigured(.medium)
        /// "Rollstuhlfahrer ohne Hilfe"
        public static let high = MobilitySettings._preconfigured(.high)

        public static func individual(noSolidStairs: Bool,
                                      noEscalators: Bool,
                                      minimumInterchangeCount: Bool,
                                      entranceOption: IndividualMobilitySettings.EntranceOption) -> MobilitySettings {
                let settings = IndividualMobilitySettings(noSolidStairs: noSolidStairs,
                                                             noEscalators: noEscalators,
                                                             minimumInterchangeCount: minimumInterchangeCount,
                                                             entranceOption: entranceOption)
                return ._individual(settings)
        }
    }

    public struct StandardSettings: Encodable {
        //swiftlint:disable:next nesting
        public enum MaxChangeCount: String, Encodable {
            /// "Nur Direktverbindungen"
            case none = "None"
            case one = "One"
            case two = "Two"
            case unlimited = "Unlimited"
        }

        let maximumInterchangeCount: MaxChangeCount

        //swiftlint:disable:next nesting
        public enum WalkingSpeed: String, Encodable {
            case verySlow = "VerySlow"
            case slow = "Slow"
            case normal = "Normal"
            case fast = "Fast"
            case veryFast = "VeryFast"
        }

        let walkingSpeed: WalkingSpeed

        //swiftlint:disable:next nesting
        public enum FootpathDistance: Int, Encodable {
            case five = 5
            case ten = 10
            case fifteen = 15
            case twenty = 20
            case thirty = 30
        }

        let footpathDistanceToStop: FootpathDistance

        let modes: [Mode]
        /// "Nahegelegene Alternativhaltestellen einschließen"
        let includeAlternativeStops: Bool

        public static var `default`: StandardSettings {
            return StandardSettings(maximumInterchangeCount: .unlimited,
                                            walkingSpeed: .normal,
                                            footpathDistanceToStop: .five,
                                            modes: Mode.all, // TODO: Should the identifiers be used instead? And what about illegal values? See dvbpy's MotType.all_request()
                                            includeAlternativeStops: true)
        }

        //swiftlint:disable:next nesting
        private enum CodingKeys: String, CodingKey {
            case maximumInterchangeCount = "maxChanges"
            case walkingSpeed
            case footpathDistanceToStop = "footpathToStop"
            case modes = "mot"
            case includeAlternativeStops
        }
    }
}

extension Route {
    public static func find(fromWithID originId: String,
                            toWithID destinationId: String,
                            time: Date = Date(),
                            dateIsArrival: Bool = false,
                            allowShortTermChanges: Bool = true,
                            mobilitySettings: MobilitySettings = .none,
                            standardSettings: StandardSettings = .default,
                            session: URLSession = .shared,
                            completion: @escaping (Result<RoutesResponse>) -> Void) {

        //swiftlint:disable:next nesting
        struct RouteData: Encodable {
            let origin: String
            let destination: String
            let time: Date
            let isarrivaltime: Bool
            let shorttermchanges: Bool
            let mobilitySettings: MobilitySettings
            let includeAlternativeStops: Bool = true
            let standardSettings: StandardSettings
        }

        let data = RouteData(origin: originId,
                             destination: destinationId,
                             time: time,
                             isarrivaltime: dateIsArrival,
                             shorttermchanges: allowShortTermChanges,
                             mobilitySettings: mobilitySettings,
                             standardSettings: standardSettings)

        post(Endpoint.route, data: data, session: session, completion: completion)
    }

    /// Convenience function taking to stop names instead of IDs. Sends of two find requests first.
    public static func find(from origin: String,
                            to destination: String,
                            time: Date = Date(),
                            dateIsArrival: Bool = false,
                            allowShortTermChanges: Bool = true,
                            mobilitySettings: MobilitySettings = .none,
                            standardSettings: StandardSettings = .default,
                            session: URLSession = .shared,
                            completion: @escaping (Result<RoutesResponse>) -> Void) {
        // FIXME: fire off these two requests in parallel, this implementation is just lazy
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
                        Route.find(fromWithID: originStop.id,
                                   toWithID: destinationStop.id,
                                   time: time,
                                   dateIsArrival: dateIsArrival,
                                   allowShortTermChanges: allowShortTermChanges,
                                   mobilitySettings: mobilitySettings,
                                   standardSettings: standardSettings,
                                   session: session,
                                   completion: completion)
                    }
                }
            }
        }
    }
}
