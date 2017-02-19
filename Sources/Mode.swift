import Foundation

public enum Mode: String {
    case tram
    case citybus
    case intercitybus
    case suburbanrailway
    case train
    case cableway
    case ferry
    case hailedsharedtaxi

    static var all: [Mode] {
        return [.tram, .citybus, .intercitybus, .suburbanrailway, .train, .cableway, .ferry, .hailedsharedtaxi]
    }

    public var identifier: String {
        switch self {
        case .tram:
            return "Tram"
        case .citybus:
            return "CityBus"
        case .intercitybus:
            return "IntercityBus"
        case .suburbanrailway:
            return "SuburbanRailway"
        case .train:
            return "Train"
        case .cableway:
            return "Cableway"
        case .ferry:
            return "Ferry"
        case .hailedsharedtaxi:
            return "HailedSharedTaxi"
        }
    }

    public var dvbIdentifier: String {
        switch self {
        case .tram:
            return "tram"
        case .citybus:
            return "citybus"
        case .intercitybus:
            return "bus"
        case .suburbanrailway:
            return "metropolitan"
        case .train:
            return "train"
        case .cableway:
            return "lift"
        case .ferry:
            return "ferry"
        case .hailedsharedtaxi:
            return "alita"
        }
    }

    public var iconURL: URL {
        return URL(string: "https://www.dvb.de/assets/img/trans-icon/transport-\(self.dvbIdentifier).svg")!
    }
}
