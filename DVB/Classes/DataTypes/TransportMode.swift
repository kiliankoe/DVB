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
        /// On-call bus
        case oncallbus = "Rufbus"
        /// Ferry
        case ferry = "Fähre"
        /// Regional bus
        case regionalbus = "Regionalbus"
        /// City train
        case citytrain = "S-Bahn"
        /// Cablecar
        case cablecar = "Seil-/Schwebebahn"
        /// Citybus
        case bus = "Stadtbus"
        /// Tram
        case tram = "Straßenbahn"
        /// Train
        case train = "Zug"

        /// Identifier used by the DVB website
        public var identifier: String {
            switch self {
            case .oncallbus:
                return "alita"
            case .ferry:
                return "ferry"
            case .regionalbus:
                return "bus"
            case .citytrain:
                return "metropolitan"
            case .cablecar:
                return "lift"
            case .bus:
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
                self = .cablecar
            case Regex("^E(\\d+)"):
                if let numStr = Regex.lastMatch?.captures[0],
                    let num = Int(numStr),
                    let type = matchNumericType(num) {
                    self = type
                } else {
                    return nil
                }
            case Regex("^EV\\d+"):
                self = .bus
            case "E":
                self = .tram
            case Regex("^\\D$|^\\D\\/\\D$"):
                self = .regionalbus
            case Regex("^F"):
                self = .ferry
            case Regex("^RE|^IC|^TL|^RB|^SB|^SE|^U\\d"):
                self = .train
            case Regex("^S"):
                self = .citytrain
            case Regex("alita"):
                self = .oncallbus
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
            return .bus
        case 100...1000:
            return .regionalbus
        default:
            return nil
    }
}
