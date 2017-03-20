import Foundation
import Marshal

public enum Mode: String {
    case Tram
    case CityBus
    case IntercityBus
    case SuburbanRailway
    case Train
    case Cableway
    case Ferry
    case HailedSharedTaxi

    static var all: [Mode] {
        return [.Tram, .CityBus, .IntercityBus, .SuburbanRailway, .Train, .Cableway, .Ferry, .HailedSharedTaxi]
    }

    public var identifier: String {
        return self.rawValue
    }

    public var dvbIdentifier: String {
        switch self {
        case .Tram:
            return "tram"
        case .CityBus:
            return "citybus"
        case .IntercityBus:
            return "bus"
        case .SuburbanRailway:
            return "metropolitan"
        case .Train:
            return "train"
        case .Cableway:
            return "lift"
        case .Ferry:
            return "ferry"
        case .HailedSharedTaxi:
            return "alita"
        }
    }

    public var iconURL: URL {
        return URL(string: "https://www.dvb.de/assets/img/trans-icon/transport-\(self.dvbIdentifier).svg")!
    }
}
