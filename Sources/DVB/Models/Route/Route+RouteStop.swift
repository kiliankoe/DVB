import Foundation

extension Route {
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
}

extension Route.RouteStop: Decodable {
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

extension Route.RouteStop: Equatable {}

extension Route.RouteStop: Hashable {}
