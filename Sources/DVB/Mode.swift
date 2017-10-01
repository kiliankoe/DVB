import Foundation

public struct Mode: Decodable {
    public let identifier: String

    public static let Tram = Mode(rawValue: "tram")
    public static let CityBus = Mode(rawValue: "citybus")
    public static let IntercityBus = Mode(rawValue: "bus")
    public static let SuburbanRailway = Mode(rawValue: "metropolitan")
    public static let Train = Mode(rawValue: "train")
    public static let Cableway = Mode(rawValue: "lift")
    public static let Ferry = Mode(rawValue: "Ferry")
    public static let HailedSharedTaxi = Mode(rawValue: "alita")

    init(value: String) {
        switch value.lowercased() {
        case Mode.Tram.identifier: self = Mode.Tram
        case Mode.CityBus.identifier: self = Mode.CityBus
        case Mode.IntercityBus.identifier, "intercitybus": self = Mode.IntercityBus
        case Mode.SuburbanRailway.identifier, "suburbanrailway": self = Mode.SuburbanRailway
        case Mode.Train.identifier: self = Mode.Train
        case Mode.Cableway.identifier, "cableway": self = Mode.Cableway
        case Mode.Ferry.identifier: self = Mode.Ferry
        case Mode.HailedSharedTaxi.identifier, "hailedsharedtaxi": self = Mode.HailedSharedTaxi
        default:
            self.identifier = value
        }
    }

    init(rawValue: String) {
        self.identifier = rawValue
    }

    public static var all: [Mode] {
        return [.Tram, .CityBus, .IntercityBus, .SuburbanRailway, .Train, .Cableway, .Ferry, .HailedSharedTaxi]
    }

    public var iconURL: URL? {
        // Only icons for the modes listed above exist
        guard Mode.all.contains(where: { $0.identifier == self.identifier }) else { return nil }
        guard let identifier = self.identifier.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else { return nil }
        return URL(string: "https://www.dvb.de/assets/trans-icon/transport-\(identifier).svg")
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.init(value: try container.decode(String.self))
    }
}
