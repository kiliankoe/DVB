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
public enum TransportMode: String {
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
    case Straßenbahn = "Straßenbahn"
    /// Train
    case Zug = "Zug"
}
