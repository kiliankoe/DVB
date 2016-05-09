//
//  Stop.swift
//  Pods
//
//  Created by Kilian Költzsch on 09/05/16.
//
//

import Foundation

/**
 *  A stop is a place where a bus, tram or whatever can stop.
 */
public struct Stop {
    /// Name of the stop
    public let name: String

    /// The town or city or other description where the stop is located
    public let location: String

    /**
     Initialize a stop.

     - parameter name:        name of the stop
     - parameter location:    location of the stop

     - returns: new Stop
     */
    public init(name: String, location: String) {
        self.name = name
        self.location = location
    }
}

extension Stop: CustomStringConvertible {
    /// A textual representation of `self`.
    public var description: String {
        return "\(name), \(location)"
    }
}
