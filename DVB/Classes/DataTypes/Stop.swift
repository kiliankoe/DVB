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
    let stops: [Stop]
    let expirationDate: Date?

    init?(json: [String: Any]) {
        guard let stops = json["Points"] as? [String] else { return nil }
        guard let expirationDate = json["ExpirationTime"] as? String else { return nil }

        self.stops = stops.map{Stop.init(string: $0)}.flatMap{$0}
        self.expirationDate = Date(from: expirationDate)
    }
}

// TODO: Put this somewhere else
internal extension Date {
    // Init with a string of the format "/Date(1487458060455+0100)/"
    init?(from dateString: String) {
        let components = dateString
            .replacingOccurrences(of: "/Date(", with: "")
            .replacingOccurrences(of: ")/", with: "")
            .components(separatedBy: "+") // FIXME: This will surely break...

        guard let millis = Int(components[0]) else { return nil }
        guard let tz = Int(components[1]) else { return nil }

        let seconds = Double(millis) / 1000 + Double(tz * 60 * 60)
        self = Date(timeIntervalSince1970: seconds)
    }
}

/// A place where a bus, tram or whatever can stop.
public struct Stop {
    public let id: String
    public let name: String
    public let region: String?
    public let location: CLLocationCoordinate2D?

    init?(string: String) {
        let components = string.components(separatedBy: "|")
        guard components.count == 8 else { return nil }
        self.id = components[0]
        self.region = components[2]
        self.name = components[3]

        let lat = components[4]
        let lng = components[5]
        // TODO: Figure out how to calculate correct location based on these values
        self.location = nil
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
