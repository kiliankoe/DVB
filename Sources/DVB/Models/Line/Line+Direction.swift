extension Line {
    public struct Direction {
        public let name: String
        public let timetables: [TimeTable]
    }
}

extension Line.Direction: Decodable {
    private enum CodingKeys: String, CodingKey {
        case name = "Name"
        case timetables = "TimeTables"
    }
}

extension Line.Direction: Equatable {}

extension Line.Direction: Hashable {}
