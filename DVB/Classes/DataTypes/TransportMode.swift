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

 - Rufbus:          Callable bus (?)
 - Faehre:          Ferry
 - Regionalbus:     Regional Bus
 - SBahn:           Commuter Train
 - SeilSchwebebahn: Cablecar
 - Stadtbus:        Bus
 - Straßenbahn:     Tram
 - Zug:             Train
 */
public enum TransportMode: String {
    case Rufbus = "Rufbus"
    case Faehre = "Fähre"
    case Regionalbus = "Regionalbus"
    case SBahn = "S-Bahn"
    case SeilSchwebebahn = "Seil-/Schwebebahn"
    case Stadtbus = "Stadtbus"
    case Straßenbahn = "Straßenbahn"
    case Zug = "Zug"
}
