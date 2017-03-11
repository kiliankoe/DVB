import Foundation
import Marshal

public struct FindResponse {
    public let stops: [Stop]
    public let expirationDate: Date?
}

/// A place where a bus, tram or whatever can stop.
public struct Stop {
    public let id: String
    public let name: String
    public let region: String?
    public let location: Coordinate?
}

// MARK: - JSON

// TODO: Remove me
extension FindResponse: FromJSON {
    init(json: JSON) throws {
        guard let stops = json["Points"] as? [String] else { throw DVBError.decode }
        guard let expirationDate = json["ExpirationTime"] as? String else { throw DVBError.decode }

        self.stops = try stops.map { try Stop(string: $0) }
        self.expirationDate = Date(from: expirationDate)
    }
}

extension FindResponse: Unmarshaling {
    public init(object: MarshaledObject) throws {
        self.stops = try object.value(for: "Points")
        self.expirationDate = try object.value(for: "ExpirationTime")
    }
}

// TODO: Remove me
extension Stop {
    init(string: String) throws {
        let components = string.components(separatedBy: "|")
        guard components.count == 9 else { throw DVBError.decode }
        self.id = components[0]
        self.region = components[2].isEmpty ? nil : components[2]
        self.name = components[3]

        guard let x = Double(components[5]),
            let y = Double(components[4]) else {
                throw DVBError.decode
        }
        if x != 0, y != 0 {
            self.location = Coordinate(x: x, y: y)
        } else {
            self.location = nil
        }
    }
}

extension Stop: ValueType {
    public static func value(from object: Any) throws -> Stop {
        guard let str = object as? String else {
            throw MarshalError.typeMismatch(expected: String.self, actual: type(of: object))
        }

        let components = str.components(separatedBy: "|")

        guard components.count == 9 else {
            throw MarshalError.typeMismatch(expected: "Stop string should have 9 different values", actual: components.count)
        }
        guard let x = Double(components[5]), let y = Double(components[4]) else {
            throw MarshalError.typeMismatch(expected: "X and Y should be number values", actual: type(of: components[5]))
        }

        let region = components[2].isEmpty ? nil : components[2]
        let location = x != 0 && y != 0 ? Coordinate(x: x, y: y) : nil

        return Stop(id: components[0], name: components[3], region: region, location: location)
    }
}

// MARK: - API

extension Stop {
    public static func find(_ query: String, completion: @escaping (Result<FindResponse>) -> Void) {
        let data: [String: Any] = [
            "limit": 0,
            "query": query,
            "stopsOnly": true,
            "dvb": true
        ]
        post(Endpoint.pointfinder, data: data, completion: completion)
    }

//    public static func findNear(lat: Double, lng: Double, completion: @escaping (Result<FindResponse>) -> Void) {
//        let coord = Coordinate(latitude: lat, longitude: lng)
//        findNear(coord: coord, completion: completion)
//    }
//
//    public static func findNear(coord: Coordinate, completion: @escaping (Result<FindResponse>) -> Void) {
//        guard let gk = wgs2gk(wgs: coord) else {
//            completion(Result(failure: DVBError.coordinate))
//            return
//        }
//        let data: [String: Any] = [
//            "limit": 0,
//            "assignedStops": true,
//            "query": "coord:\(Int(gk.x)):\(Int(gk.y))"
//        ]
//        post(Endpoint.pointfinder, data: data, completion: completion)
//    }
}

// MARK: - Utility

extension Stop: CustomStringConvertible {
    public var description: String {
        if let region = region, !region.isEmpty {
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
