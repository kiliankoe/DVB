extension RouteChange {
    public struct Line {
        public let id: String
        public let name: String
        public let transportationCompany: String
        public let mode: Mode
        public let divas: [Diva]
        public let changes: [String]
    }
}

extension RouteChange.Line: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
        case transportationCompany = "TransportationCompany"
        case mode = "Mot"
        case divas = "Divas"
        case changes = "Changes"
    }
}

extension RouteChange.Line: Equatable {}

extension RouteChange.Line: Hashable {}
