//
//  Stop.swift
//  Pods
//
//  Created by Kilian Költzsch on 09/05/16.
//
//

import Foundation
import MapKit

/// A place where a bus, tram or whatever can stop.
public struct Stop {

    /// This is currently not really necessary, will be when matching with additional data
    let id: Int

    /// Name of the stop
    public let name: String

    /// The town or city or other description where the stop is located
    public let region: String

    /// String elements used for finding this stop
    public let searchString: String

    /// A list of tarif zones that this stop is included in
    public let tarifZones: String

    /// The coordinate where the stop is located
    public let location: CLLocationCoordinate2D?

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

    /// Initialize a new stop
    ///
    /// - parameter id:           unique identifier
    /// - parameter name:         name
    /// - parameter region:       region
    /// - parameter searchString: string elements used for identifying this stop
    /// - parameter tarifZones:   list of tarif zones this stop is included in
    /// - parameter longitude:    longitude
    /// - parameter latitude:     latitude
    /// - parameter priority:     static priority for users searching in Dresden
    ///
    /// - returns: new stop
    public init(id: Int, name: String, region: String, searchString: String, tarifZones: String, longitude: Double, latitude: Double, priority: Int) {
        self.id = id
        self.name = name
        self.region = region
        self.searchString = searchString
        self.tarifZones = tarifZones
        self.location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.priority = priority
    }

    init?(dict: [String:String]) {
        if let idVal = dict["id"], let id = Int(idVal),
            let name = dict["name"],
            let region = dict["region"],
            let searchString = dict["searchstring"],
            let tarifZones = dict["tarif_zones"],
            let latVal = dict["latitude"], let lat = Double(latVal),
            let lngVal = dict["longitude"], let lng = Double(lngVal),
            let priorityVal = dict["priority"], let priority = Int(priorityVal) {
                self.id = id
                self.region = region
                self.name = name
                self.searchString = searchString
                self.tarifZones = tarifZones
                self.priority = priority

                if lat != 999.999999 { // Some stops have no sane location data 🙁
                    self.location = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                } else {
                    self.location = nil
                }
        } else {
            return nil
        }
    }
}

extension Stop: CustomStringConvertible {
    /// A textual representation of `self`.
    public var description: String {
        return "\(name), \(region)"
    }
}

extension Stop: Equatable {
	// Intentionally left blank
}

/// Stop equality
public func == (lhs: Stop, rhs: Stop) -> Bool {
	return lhs.hashValue == rhs.hashValue
}

extension Stop: Hashable {
	/// Unique hash value based on `id`
	public var hashValue: Int {
		get {
			return self.id.hashValue
		}
	}
}
