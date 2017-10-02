import Foundation

public struct RouteChangeResponse: Decodable {
    public let lines: [RouteChange.Line]
    public let changes: [RouteChange]

    private enum CodingKeys: String, CodingKey {
        case lines = "Lines"
        case changes = "Changes"
    }
}

public struct RouteChange: Decodable {
    public let id: String
    public let kind: Kind
    public let tripRequestInclude: Bool?
    public let title: String
    public let htmlDescription: String
    public let validityPeriods: [ValidityPeriod]
    public let lineIds: [String]
    public let publishDate: Date

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

extension RouteChange {
    public struct Line: Decodable {
        public let id: String
        public let name: String
        public let transportationCompany: String
        public let mode: Mode
        public let divas: [Diva]
        public let changes: [String]

        private enum CodingKeys: String, CodingKey {
            case id = "Id"
            case name = "Name"
            case transportationCompany = "TransportationCompany"
            case mode = "Mot"
            case divas = "Divas"
            case changes = "Changes"
        }
    }

    public struct ValidityPeriod: Decodable {
        public let begin: Date
        public let end: Date?

        private enum CodingKeys: String, CodingKey {
            case begin = "Begin"
            case end = "End"
        }
    }

    public struct Kind: Decodable {
        public let rawValue: String

        public static let Scheduled = Kind(rawValue: "Scheduled")
        public static let AmplifyingTransport = Kind(rawValue: "AmplifyingTransport")
        public static let ShortTerm = Kind(rawValue: "ShortTerm")

        public init(rawValue value: String) {
            self.rawValue = value
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            self.rawValue = try container.decode(String.self)
        }
    }
}

// MARK: - API

extension RouteChange {
    public static func get(shortTerm: Bool = true, session: URLSession = .shared, completion: @escaping (Result<RouteChangeResponse>) -> Void) {
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

extension RouteChange: Equatable {}
public func == (lhs: RouteChange, rhs: RouteChange) -> Bool {
    return lhs.id == rhs.id
}

extension RouteChange: Hashable {
    public var hashValue: Int {
        return self.id.hashValue
    }
}
