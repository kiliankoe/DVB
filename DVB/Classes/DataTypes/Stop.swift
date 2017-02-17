//
//  Stop.swift
//  Pods
//
//  Created by Kilian Költzsch on 09/05/16.
//
//

import Foundation
import MapKit

public struct FindResponse {
    let points: [Stop]
    let expirationDate: Date
}

/// A place where a bus, tram or whatever can stop.
public struct Stop {

    let id: Int
    public let name: String
    public let region: String?
    public let location: CLLocationCoordinate2D?

    init?(dict: [String:String]) {
        if let idVal = dict["id"], let id = Int(idVal),
            let name = dict["name"],
            let region = dict["region"],
            let latVal = dict["latitude"], let lat = Double(latVal),
            let lngVal = dict["longitude"], let lng = Double(lngVal) {
                self.id = id
                self.region = region
                self.name = name

                // TODO: Find out how to calculate correct location based on the API values
                self.location = nil
        } else {
            return nil
        }
    }
}

extension Stop: CustomStringConvertible {
    public var description: String {
        if let region = region {
            return "\(name), \(region)"
        }
        return name
    }
}

extension Stop: Equatable {}
public func == (lhs: Stop, rhs: Stop) -> Bool {
	return lhs.hashValue == rhs.hashValue
}

extension Stop: Hashable {
	public var hashValue: Int {
        return self.id.hashValue
	}
}
