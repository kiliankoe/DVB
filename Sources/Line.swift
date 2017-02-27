import Foundation

public struct LinesResponse {
    public let lines: [Line]
    public let expirationDate: Date
}

public struct Line {
    public struct Direction {
        public let name: String
        public let timetables: [TimeTable]
    }

    public struct TimeTable {
        public let id: String
        public let name: String
    }

    public let name: String
    public let mode: Mode
    public let changes: [String]?
    public let directions: [Direction]
    public let diva: Diva?
}

// MARK: - JSON

extension LinesResponse: FromJSON {
    init(json: JSON) throws {
        guard
            let lines = json["Lines"] as? [JSON],
            let expirationStr = json["ExpirationTime"] as? String,
            let expirationDate = Date(from: expirationStr)
        else {
            throw DVBError.decode
        }

        self.lines = try lines.map { try Line(json: $0) }
        self.expirationDate = expirationDate
    }
}

extension Line: FromJSON {
    init(json: JSON) throws {
        guard
            let name = json["Name"] as? String,
            let modeStr = json["Mot"] as? String,
            let mode = Mode(rawValue: modeStr.lowercased()),
            let directions = json["Directions"] as? [JSON]
        else {
            throw DVBError.decode
        }

        self.name = name
        self.mode = mode
        self.directions = try directions.map { try Direction(json: $0) }

        if let changes = json["Changes"] as? [String] {
            self.changes = changes
        } else {
            self.changes = nil
        }

        if let diva = json["Diva"] as? JSON {
            self.diva = try Diva(json: diva)
        } else {
            self.diva = nil
        }
    }
}

extension Line.Direction: FromJSON {
    init(json: JSON) throws {
        guard
            let name = json["Name"] as? String,
            let timetables = json["TimeTables"] as? [JSON]
        else {
            throw DVBError.decode
        }

        self.name = name
        self.timetables = try timetables.map { try Line.TimeTable(json: $0) }
    }
}

extension Line.TimeTable: FromJSON {
    init(json: JSON) throws {
        guard
            let name = json["Name"] as? String,
            let id = json["Id"] as? String
        else {
            throw DVBError.decode
        }

        self.name = name
        self.id = id
    }
}

// MARK: - API

extension Line {
    public static func get(forStopId id: String, completion: @escaping (Result<LinesResponse>) -> Void) {
        let data = [
            "stopid": id
        ]
        post(Endpoint.lines, data: data, completion: completion)
    }

    /// Convenience function taking a stop name. Sends of a find request first and uses the first result's `id` as an argument for the lines request.
    public static func get(forStopName name: String, completion: @escaping (Result<LinesResponse>) -> Void) {
        Stop.find(query: name) { result in
            switch result {
            case .failure(let error): completion(Result(failure: error))
            case .success(let response):
                guard let first = response.stops.first else {
                    completion(Result(failure: DVBError.response))
                    return
                }
                Line.get(forStopId: first.id, completion: completion)
            }
        }
    }
}

// MARK: - Utility

extension Line: CustomStringConvertible {
    public var description: String {
        let dirs = directions.map { $0.name }.joined(separator: ", ")
        return "\(name): \(dirs)"
    }
}

extension Line: Equatable {}
public func == (lhs: Line, rhs: Line) -> Bool {
    return lhs.name == rhs.name && lhs.directions == rhs.directions
}

extension Line.Direction: Equatable {}
public func == (lhs: Line.Direction, rhs: Line.Direction) -> Bool {
    return lhs.name == rhs.name && lhs.timetables == rhs.timetables
}

extension Line.TimeTable: Equatable {}
public func == (lhs: Line.TimeTable, rhs: Line.TimeTable) -> Bool {
    return lhs.id == rhs.id
}
