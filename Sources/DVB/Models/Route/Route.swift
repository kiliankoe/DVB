import Foundation

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

extension Route: Decodable {
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

extension Route: Equatable {}

extension Route: Hashable {}

// MARK: - API

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
                guard let originStop = response.stops.first else {
                    completion(Result(failure: DVBError.response))
                    return
                }
                Stop.find(destination, session: session) { result in
                    switch result {
                    case let .failure(error): completion(Result(failure: error))
                    case let .success(response):
                        guard let destinationStop = response.stops.first else {
                            completion(Result(failure: DVBError.response))
                            return
                        }
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
