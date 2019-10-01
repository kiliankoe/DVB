import Foundation

public enum Mode {
    case tram
    case cityBus
    case intercityBus
    case plusBus
    case suburbanRailway
    case train
    case cableway
    case ferry
    case hailedSharedTaxi

    case footpath
    case rapidTransit

    /// A placeholder value for future additions.
    case unknown(String)

    public var rawValue: String {
        switch self {
        case .tram: return "tram"
        case .cityBus: return "citybus"
        case .intercityBus: return "intercitybus"
        case .plusBus: return "plusbus"
        case .suburbanRailway: return "suburbanrailway"
        case .train: return "train"
        case .cableway: return "lift"
        case .ferry: return "ferry"
        case .hailedSharedTaxi: return "alita"
        case .footpath: return "footpath"
        case .rapidTransit: return "rapidtransit"
        case .unknown(let value): return value
        }
    }

    /// All modes of transport relevant for requests to the VVO WebAPI.
    public static var allRequest: [Mode] {
        return [
            .tram,
            .cityBus,
            .intercityBus,
            .plusBus,
            .suburbanRailway,
            .train,
            .cableway,
            .ferry,
            .hailedSharedTaxi
        ]
    }

    public var iconURL: URL? {
        // Only icons for the modes listed above exist
        guard Mode.allRequest.contains(self) else { return nil }
        guard var identifier = self.rawValue
            .addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else { return nil }
        if identifier == "citybus" || identifier == "intercitybus" {
            // no clue why this appears to be necessary...
            identifier = "bus"
        }
        return URL(string: "https://www.dvb.de/assets/img/trans-icon/transport-\(identifier).svg")
    }
}

extension Mode: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        var value = try container.decode(String.self)
        value = value.lowercased()
        if let mode = Mode.allRequest.first(where: { $0.rawValue == value }) {
            self = mode
        } else {
            print("Unknown mode of transport '\(value)', please open an issue on https://github.com/kiliankoe/DVB for this, thanks!")
            self = .unknown(value)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }
}

extension Mode: Equatable {}

extension Mode: Hashable {}
