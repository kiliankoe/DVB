extension RouteChange {
    public enum Kind {
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

        static var allCases: [Kind] {
            return [.scheduled, .amplifyingTransport, .shortTerm]
        }
    }
}

extension RouteChange.Kind: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        if let kind = RouteChange.Kind.allCases.first(where: { $0.rawValue == value }) {
            self = kind
        } else {
            print("Unknown routechange kind '\(value)', please open an issue on https://github.com/kiliankoe/DVB for this, thanks!")
            self = .unknown(value)
        }
    }
}

extension RouteChange.Kind: Equatable {}

extension RouteChange.Kind: Hashable {}
