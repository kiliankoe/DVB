import Foundation

public struct RouteChange {
    public let id: String
    public let kind: Kind
    public let tripRequestInclude: Bool?
    public let title: String
    public let htmlDescription: String
    public let validityPeriods: [ValidityPeriod]
    public let lineIds: [String]
    public let publishDate: Date
}

extension RouteChange: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id = "Id"
        case kind = "Type"
        case tripRequestInclude = "TripRequestInclude"
        case title = "Title"
        case htmlDescription = "Description"
        case validityPeriods = "ValidityPeriods"
        case lineIds = "LineIds"
        case publishDate = "PublishDate"
    }
}

extension RouteChange: Equatable {}

extension RouteChange: Hashable {}

// MARK: - API

extension RouteChange {
    public static func get(shortTerm: Bool = true,
                           session: URLSession = .shared,
                           completion: @escaping (Result<RouteChangeResponse>) -> Void) {
        let data = [
            "shortterm": shortTerm,
        ]

        post(Endpoint.routeChanges, data: data, session: session, completion: completion)
    }
}

// MARK: - Utiliy

extension RouteChange: CustomStringConvertible {
    public var description: String {
        return self.title
    }
}
