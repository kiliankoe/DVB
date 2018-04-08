import Foundation

public struct Platform: Decodable, Equatable, Hashable {
    public let name: String
    public let type: String

    private enum CodingKeys: String, CodingKey {
        case name = "Name"
        case type = "Type"
    }
}
