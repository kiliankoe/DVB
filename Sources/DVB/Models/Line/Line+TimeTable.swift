extension Line {
    public struct TimeTable {
        public let id: String
        public let name: String
    }
}

extension Line.TimeTable: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
    }
}

extension Line.TimeTable: Equatable {}

extension Line.TimeTable: Hashable {}
