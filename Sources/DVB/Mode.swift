import Foundation

public struct Mode: Decodable {
    public let identifier: String

    public static let Tram = Mode(value: "tram")
    public static let CityBus = Mode(value: "citybus")
    public static let IntercityBus = Mode(value: "bus")
    public static let SuburbanRailway = Mode(value: "metropolitan")
    public static let Train = Mode(value: "train")
    public static let Cableway = Mode(value: "lift")
    public static let Ferry = Mode(value: "Ferry")
    public static let HailedSharedTaxi = Mode(value: "alita")

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

    public static var all: [Mode] {
        return [.Tram, .CityBus, .IntercityBus, .SuburbanRailway, .Train, .Cableway, .Ferry, .HailedSharedTaxi]
    }

    public var iconURL: URL? {
        guard let identifier = self.identifier.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else { return nil }
        return URL(string: "https://www.dvb.de/assets/trans-icon/transport-\(identifier).svg")
    }
}
