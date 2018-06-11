extension Departure {
    public enum State {
        case onTime
        case delayed
        case unknown(String)

        public var rawValue: String {
            switch self {
            case .onTime: return "InTime"
            case .delayed: return "Delayed"
            case .unknown(let value): return value
            }
        }

        static var all: [State] {
            return [.onTime, .delayed]
        }
    }
}

extension Departure.State: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        if let state = Departure.State.all.first(where: { $0.rawValue == value }) {
            self = state
        } else {
            print("Unknown departure state '\(value)', please open an issue on https://github.com/kiliankoe/DVB for this, thanks!")
            self = .unknown(value)
        }
    }
}

extension Departure.State: Equatable {}

extension Departure.State: Hashable {}
