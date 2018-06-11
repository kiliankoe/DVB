public struct Platform {
    public let name: String
    public let type: String
}

extension Platform: Decodable {
    private enum CodingKeys: String, CodingKey {
        case name = "Name"
        case type = "Type"
    }
}

extension Platform: Equatable {}

extension Platform: Hashable {}
