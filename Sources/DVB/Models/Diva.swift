import Foundation

public struct Diva {
    public let number: String
    public let network: String
}

extension Diva: Decodable {
    private enum CodingKeys: String, CodingKey {
        case number = "Number"
        case network = "Network"
    }
}

extension Diva: Equatable {}

extension Diva: Hashable {}
