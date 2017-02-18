//
//  TransportMode.swift
//  Pods
//
//  Created by Kilian Költzsch on 07/05/16.
//
//

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

    var all: [String] {
        return [
            "Tram",
            "CityBus",
            "IntercityBus",
            "SuburbanRailway",
            "Train",
            "Cableway",
            "Ferry",
            "HailedSharedTaxi"
        ]
    }

    // as used by the DVB
    public var identifier: String {
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
        return URL(string: "https://www.dvb.de/assets/img/trans-icon/transport-\(self.identifier).svg")!
    }
}
