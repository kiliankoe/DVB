import Foundation

public struct LinesResponse: Decodable, Equatable {
    public let lines: [Line]
    public let expirationTime: Date

    private enum CodingKeys: String, CodingKey {
        case lines = "Lines"
        case expirationTime = "ExpirationTime"
    }
}

public struct Line: Decodable, Equatable {
    public let name: String
    public let mode: Mode
    public let changes: [String]?
    public let directions: [Direction]
    public let diva: Diva?

    private enum CodingKeys: String, CodingKey {
        case name = "Name"
        case mode = "Mot"
        case changes = "Changes"
        case directions = "Directions"
        case diva = "Diva"
    }
}

extension Line {
    public struct Direction: Decodable, Equatable {
        public let name: String
        public let timetables: [TimeTable]

        //swiftlint:disable:next nesting
        private enum CodingKeys: String, CodingKey {
            case name = "Name"
            case timetables = "TimeTables"
        }
    }

    public struct TimeTable: Decodable, Equatable, Hashable {
        public let id: String
        public let name: String

        //swiftlint:disable:next nesting
        private enum CodingKeys: String, CodingKey {
            case id = "Id"
            case name = "Name"
        }
    }
}

// MARK: - API

extension Line {
    public static func get(forStopId id: String,
                           session: URLSession = .shared,
                           completion: @escaping (Result<LinesResponse>) -> Void) {
        let data = [
            "stopid": id,
        ]
        post(Endpoint.lines, data: data, session: session, completion: completion)
    }

    /// Convenience function taking a stop name. Sends of a find request first and uses the first result's `id` as an argument for the lines request.
    public static func get(forStopName name: String,
                           session: URLSession = .shared,
                           completion: @escaping (Result<LinesResponse>) -> Void) {
        Stop.find(name, session: session) { result in
            switch result {
            case let .failure(error): completion(Result(failure: error))
            case let .success(response):
                guard let first = response.stops.first else {
                    completion(Result(failure: DVBError.response))
                    return
                }
                Line.get(forStopId: first.id, session: session, completion: completion)
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

extension Line: Hashable {
    public var hashValue: Int {
        return self.name.hashValue ^ self.mode.hashValue
    }
}

extension Line.Direction: Hashable {
    public var hashValue: Int {
        return self.name.hashValue
    }
}
