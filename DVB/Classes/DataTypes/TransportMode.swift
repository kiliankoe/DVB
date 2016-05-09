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
    }
    public enum Route: String {
        case Placeholder = "Placeholder"
    }
}
