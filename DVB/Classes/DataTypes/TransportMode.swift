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
    /// Available modes of transport for the Monitor endpoint
    public enum Monitor: String {
        /// Callable Taxi/Bus (?)
        case ASTRufbus = "Rufbus"
        /// Ferry
        case Faehre = "Fähre"
        /// Regional Bus
        case Regionalbus = "Regionalbus"
        /// Commuter Train
        case SBahn = "S-Bahn"
        /// Cablecar
        case SeilSchwebebahn = "Seil-/Schwebebahn"
        /// Citybus
        case Stadtbus = "Stadtbus"
        /// Tram
        case Strassenbahn = "Straßenbahn"
        /// Train
        case Zug = "Zug"

        /// Identifier used by the DVB website
        public var identifier: String {
            switch self {
            case .ASTRufbus:
                return "alita"
            case .Faehre:
                return "ferry"
            case .Regionalbus:
                return "bus"
            case .SBahn:
                return "metropolitan"
            case .SeilSchwebebahn:
                return "lift"
            case .Stadtbus:
                return "citybus"
            case .Strassenbahn:
                return "tram"
            case .Zug:
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
