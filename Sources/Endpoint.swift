//
//  URL.swift
//  Pods
//
//  Created by Kilian Költzsch on 06/05/16.
//
//

import Foundation

enum Endpoint {
    static let base = URL(string: "https://webapi.vvo-online.de/")!
    static let pointfinder = URL(string: "tr/pointfinder", relativeTo: Endpoint.base)!
    static let departureMonitor = URL(string: "dm", relativeTo: Endpoint.base)!
}
