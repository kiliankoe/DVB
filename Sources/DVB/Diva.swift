import Foundation

public struct Diva: Decodable {
    public let number: String
    public let network: String

    private enum CodingKeys: String, CodingKey {
        case number = "Number"
        case network = "Network"
    }
}
