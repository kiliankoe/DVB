extension Route {
    public struct ModeElement {
        public let name: String?
        public let mode: Mode?
        public let direction: String?
        public let changes: [String]?
        public let diva: Diva?
    }
}

extension Route.ModeElement: Decodable {
    private enum CodingKeys: String, CodingKey {
        case name = "Name"
        case mode = "Type"
        case direction = "Direction"
        case changes = "Changes"
        case diva = "Diva"
    }
}

extension Route.ModeElement: Equatable {}

extension Route.ModeElement: Hashable {}
