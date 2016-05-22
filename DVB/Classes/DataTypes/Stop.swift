//
//  Stop.swift
//  Pods
//
//  Created by Kilian Költzsch on 09/05/16.
//
//

import Foundation
import MapKit

/**
 *  A place where a bus, tram or whatever can stop.
 */
public struct Stop {

    /// This is currently not really necessary, will be when matching with additional data
    internal let id: Int

    /// Name of the stop
    public let name: String

    /// The town or city or other description where the stop is located
    public let region: String

    /// String elements used for finding this stop
    public let searchString: String

    /// A list of tarif zones that this stop is included in
    public let tarifZones: String

    /// The coordinate where the stop is located
    public let location: CLLocationCoordinate2D

//    /// Bike and Ride is available at this stop
//    public let isBikeAndRide: Bool
//
//    /// Park and Ride is available at this stop
//    public let isParkAndRide: Bool
//
//    /// This stop is accessible for handicapped users
//    public let isAccessible: Bool

    /// The static priority for users searching from within Dresden
    internal let priority: Int

    /**
     Initialize a new stop

     - parameter id:           unique identifier
     - parameter name:         name
     - parameter region:       region
     - parameter searchString: string elements used for identifying this stop
     - parameter tarifZones:   list of tarif zones this stop is included in
     - parameter longitude:    longitude
     - parameter latitude:     latitude
     - parameter priority:     static priority for users searching in Dresden

     - returns: new Stop
     */
    public init(id: Int, name: String, region: String, searchString: String, tarifZones: String, longitude: Double, latitude: Double, priority: Int) {
        self.id = id
        self.name = name
        self.region = region
        self.searchString = searchString
        self.tarifZones = tarifZones
        self.location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.priority = priority
    }
}

extension Stop: CustomStringConvertible {
    /// A textual representation of `self`.
    public var description: String {
        return "\(name), \(region)"
    }
}
