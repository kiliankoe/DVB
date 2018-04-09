import Foundation

public struct RouteChangeResponse: Decodable, Equatable {
    public let lines: [RouteChange.Line]
    public let changes: [RouteChange]

    private enum CodingKeys: String, CodingKey {
        case lines = "Lines"
        case changes = "Changes"
    }
}

public struct RouteChange: Decodable, Equatable {
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
    public struct Line: Decodable, Equatable {
        public let id: String
        public let name: String
        public let transportationCompany: String
        public let mode: Mode
        public let divas: [Diva]
        public let changes: [String]

        //swiftlint:disable:next nesting
        private enum CodingKeys: String, CodingKey {
            case id = "Id"
            case name = "Name"
            case transportationCompany = "TransportationCompany"
            case mode = "Mot"
            case divas = "Divas"
            case changes = "Changes"
        }
    }

    public struct ValidityPeriod: Decodable, Equatable {
        public let begin: Date
        public let end: Date?

        //swiftlint:disable:next nesting
        private enum CodingKeys: String, CodingKey {
            case begin = "Begin"
            case end = "End"
        }
    }

    public enum Kind: Decodable, Equatable, Hashable {
        case scheduled
        case amplifyingTransport
        case shortTerm
        case unknown(String)

        public var rawValue: String {
            switch self {
            case .scheduled: return "Scheduled"
            case .amplifyingTransport: return "AmplifyingTransport"
            case .shortTerm: return "ShortTerm"
            case .unknown(let value): return value
            }
        }

        static var all: [Kind] {
            return [.scheduled, .amplifyingTransport, .shortTerm]
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let value = try container.decode(String.self)
            if let kind = Kind.all.first(where: { $0.rawValue == value }) {
                self = kind
            } else {
                print("Unknown routechange kind '\(value)', please open an issue on https://github.com/kiliankoe/DVB for this, thanks!")
                self = .unknown(value)
            }
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

extension RouteChange: Hashable {
    public var hashValue: Int {
        return self.id.hashValue
    }
}

extension RouteChange.Line: Hashable {
    public var hashValue: Int {
        return self.id.hashValue
    }
}
