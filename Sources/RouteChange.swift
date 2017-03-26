import Foundation
import Marshal

public struct RouteChangeResponse {
    public let lines: [RouteChange.Line]
    public let changes: [RouteChange]
}

public struct RouteChange {
    public struct ValidityPeriod {
        public let begin: Date
        public let end: Date?
    }

    public enum Kind {
        case scheduled
        case amplifyingTransport
        case shortTerm
        case other(String)

        init(_ string: String) {
            switch string {
            case "Scheduled": self = .scheduled
            case "AmplifyingTransport": self = .amplifyingTransport
            case "ShortTerm": self = .shortTerm
            default: self = .other(string)
            }
        }
    }

    public let id: String
    public let kind: Kind
    public let tripRequestInclude: Bool?
    public let title: String
    public let htmlDescription: String
    public let validityPeriods: [ValidityPeriod]
    public let lineIds: [String]
    public let publishDate: Date
}

extension RouteChange {
    public struct Line {
        public let id: String
        public let name: String
        public let transportationCompany: String
        public let mode: Mode
        public let divas: [Diva]
        public let changes: [String]
    }
}

// MARK: - JSON

extension RouteChangeResponse: Unmarshaling {
    public init(object: MarshaledObject) throws {
        lines = try object <| "Lines"
        changes = try object <| "Changes"
    }
}

extension RouteChange: Unmarshaling {
    public init(object: MarshaledObject) throws {
        id = try object <| "Id"
        kind = try object <| "Type"
        tripRequestInclude = try object <| "TripRequestInclude"
        title = try object <| "Title"
        htmlDescription = try object <| "Description"
        validityPeriods = try object <| "ValidityPeriods"
        lineIds = try object <| "LineIds"
        publishDate = try object <| "PublishDate"
    }
}

extension RouteChange.Kind: ValueType {
    public static func value(from object: Any) throws -> RouteChange.Kind {
        guard let kindStr = object as? String else {
            throw MarshalError.typeMismatch(expected: String.self, actual: type(of: object))
        }
        return self.init(kindStr)
    }
}

extension RouteChange.Line: Unmarshaling {
    public init(object: MarshaledObject) throws {
        id = try object <| "Id"
        name = try object <| "Name"
        transportationCompany = try object <| "TransportationCompany"
        mode = try object <| "Mot"
        divas = try object <| "Divas"
        changes = try object <| "Changes"
    }
}

extension RouteChange.ValidityPeriod: Unmarshaling {
    public init(object: MarshaledObject) throws {
        begin = try object <| "Begin"
        end = try object <| "End"
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

extension RouteChange.Kind: Equatable {}
public func == (lhs: RouteChange.Kind, rhs: RouteChange.Kind) -> Bool {
    switch (lhs, rhs) {
    case (.scheduled, .scheduled): return true
    case (.amplifyingTransport, .amplifyingTransport): return true
    case let (.other(x), .other(y)): return x == y
    default: return false
    }
}
