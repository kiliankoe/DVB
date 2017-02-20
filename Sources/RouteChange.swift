import Foundation

public struct RouteChangeResponse {
    public let lines: [Line]
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

// MARK: - JSON

extension RouteChangeResponse: FromJSON {
    init?(json: JSON) {
        guard let lines = json["Lines"] as? [JSON],
            let changes = json["Changes"] as? [JSON] else {
                return nil
        }

        self.lines = lines.map {Line(json: $0)}.flatMap {$0}
        self.changes = changes.map {RouteChange(json: $0)}.flatMap {$0}
    }
}

extension RouteChange: FromJSON {
    init?(json: JSON) {
        guard let id = json["Id"] as? String,
            let kindStr = json["Type"] as? String,
            let title = json["Title"] as? String,
            let html = json["Description"] as? String,
            let valPeriods = json["ValidityPeriods"] as? [JSON],
            let lineIds = json["LineIds"] as? [String],
            let publishDateStr = json["PublishDate"] as? String,
            let publishDate = Date(from: publishDateStr) else {
                return nil
        }

        self.id = id
        self.kind = Kind(kindStr)
        self.tripRequestInclude = json["TripRequestInclude"] as? Bool
        self.title = title
        self.htmlDescription = html
        self.validityPeriods = valPeriods.map {ValidityPeriod(json: $0)}.flatMap {$0}
        self.lineIds = lineIds
        self.publishDate = publishDate
    }
}

extension RouteChange.ValidityPeriod: FromJSON {
    init?(json: JSON) {
        guard let beginStr = json["Begin"] as? String,
            let begin = Date(from: beginStr),
                return nil
        }

        self.begin = begin

        if let endStr = json["End"] as? String,
            let end = Date(from: endStr) {
            self.end = end
        } else {
            self.end = nil
        }
    }
}

// MARK: - API

extension RouteChange {
    public static func get(shortTerm: Bool = true, completion: @escaping (Result<RouteChangeResponse>) -> Void) {
        let data = [
            "shortterm": shortTerm
        ]

        post(Endpoint.routeChanges, data: data, completion: completion)
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
    case (.other(let x), .other(let y)): return x == y
    default: return false
    }
}
