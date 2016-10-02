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
    }
    public enum Route: String {
        case Placeholder = "Placeholder"
    }
}
