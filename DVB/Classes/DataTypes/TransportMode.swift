//
//  TransportMode.swift
//  Pods
//
//  Created by Kilian Költzsch on 07/05/16.
//
//

import Foundation

/**
 Available modes of transport
 */
public enum TransportMode {
    /// Available modes of transport for the departures endpoint
    public enum Departures: String {
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

        /// Internal initializer parsing the type using regex magic
        ///
        /// - parameter line: line identifier
        init?(line: String) {
            if let line = Int(line) {
                switch line {
                case 0...60:
                    self = .tram
                case 61..<100:
                    self = .bus
                case 100...1000:
                    self = .regionalbus
                default:
                    return nil
                }
                return
            }

            if line == "SWB" {
                self = .cablecar
                return
            }

            if let _ = line.range(of: "^E(\\d+)", options: .regularExpression) {
                var numStr = line
                numStr.remove(at: numStr.startIndex)
                if let num = Int(numStr) {
                    switch num {
                    case 0...60:
                        self = .tram
                    case 61..<100:
                        self = .bus
                    default:
                        return nil
                    }
                    return
                }
            }

            if let _ = line.range(of: "^EV\\d+", options: .regularExpression) {
                self = .bus
                return
            }

            if line == "E" {
                self = .tram
                return
            }

            if let _ = line.range(of: "^\\D$|^\\D\\/\\D$", options: .regularExpression) {
                self = .regionalbus
                return
            }

            if let _ = line.range(of: "^F", options: .regularExpression) {
                self = .ferry
                return
            }

            if let _ = line.range(of: "^RE|^IC|^TL|^RB|^SB|^SE|^U\\d", options: .regularExpression) {
                self = .train
                return
            }

            if let _ = line.range(of: "^S", options: .regularExpression) {
                self = .citytrain
                return
            }
            
            if line.contains("alita") {
                self = .oncallbus
                return
            }
            
            print("Failed to parse departure identifier into transport mode for \"\(line)\"")
            return nil
        }
    }
}
