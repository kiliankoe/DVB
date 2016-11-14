//
//  TransportMode.swift
//  Pods
//
//  Created by Kilian Költzsch on 07/05/16.
//
//

import Foundation
import Regex

/**
 Available modes of transport
 */
public enum TransportMode {
    /// Available modes of transport for the departures endpoint
    public enum Departure: String {
        /// Hailed Shared Taxi
        case hailedSharedTaxi = "Rufbus"
        /// Ferry
        case ferry = "Fähre"
        /// Intercity Bus
        case intercityBus = "Regionalbus"
        /// Suburban Railway
        case suburbanRailway = "S-Bahn"
        /// Cableway
        case cableway = "Seil-/Schwebebahn"
        /// City Bus
        case cityBus = "Stadtbus"
        /// Tram
        case tram = "Straßenbahn"
        /// Train
        case train = "Zug"

        /// Identifier used by the DVB website
        public var identifier: String {
            switch self {
            case .hailedSharedTaxi:
                return "alita"
            case .ferry:
                return "ferry"
            case .intercityBus:
                return "bus"
            case .suburbanRailway:
                return "metropolitan"
            case .cableway:
                return "lift"
            case .cityBus:
                return "citybus"
            case .tram:
                return "tram"
            case .train:
                return "train"
            }
        }

        /// URL of the matching SVG icon
        public var iconURL: Foundation.URL {
            return Foundation.URL(string: "https://www.dvb.de/assets/img/trans-icon/transport-\(self.identifier).svg")!
        }

        /// Internal initializer parsing the type using regex magic ✨
        ///
        /// - parameter line: line identifier
        ///
        /// - returns: TransportMode
        init?(line: String) { // swiftlint:disable:this cyclomatic_complexity
            if let lineInt = Int(line), let type = matchNumericType(lineInt) {
                self = type
                return
            }

            switch line {
            case "SWB":
                self = .cableway
            case Regex("^E(\\d+)"):
                if let numStr = Regex.lastMatch?.captures[0],
                    let num = Int(numStr),
                    let type = matchNumericType(num) {
                    self = type
                } else {
                    return nil
                }
            case Regex("^EV\\d+"):
                self = .cityBus
            case "E":
                self = .tram
            case Regex("^\\D$|^\\D\\/\\D$"):
                self = .intercityBus
            case Regex("^F"):
                self = .ferry
            case Regex("^RE|^IC|^TL|^RB|^SB|^SE|^U\\d"):
                self = .train
            case Regex("^S"):
                self = .suburbanRailway
            case Regex("alita"):
                self = .hailedSharedTaxi
            default:
                print("Failed to parse departure identifier into transport mode for \"\(line)\"")
                return nil
            }
        }
    }
}

/// Internal helper matching an integer to a specific TransportMode.Departure
///
/// - parameter int: line identifier
///
/// - returns: TransportMode.Departure?
fileprivate func matchNumericType(_ int: Int) -> TransportMode.Departure? {
    switch int {
        case 0...60:
            return .tram
        case 61..<100:
            return .cityBus
        case 100...1000:
            return .intercityBus
        default:
            return nil
    }
}
