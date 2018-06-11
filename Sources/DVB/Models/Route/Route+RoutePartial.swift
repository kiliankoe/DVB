extension Route {
    public struct RoutePartial {
        public let partialRouteId: Int?
        public let duration: Int?
        public let mode: ModeElement
        public let mapDataIndex: Int
        public let shift: String
        public let regularStops: [RouteStop]?
    }
}

extension Route.RoutePartial: Decodable {
    private enum CodingKeys: String, CodingKey {
        case partialRouteId = "PartialRouteId"
        case duration = "Duration"
        case mode = "Mot"
        case mapDataIndex = "MapDataIndex"
        case shift = "Shift"
        case regularStops = "RegularStops"
    }
}

extension Route.RoutePartial: Equatable {}

extension Route.RoutePartial: Hashable {}
