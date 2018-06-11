import Foundation

public struct LinesResponse: Decodable, Equatable {
    public let lines: [Line]
    public let expirationTime: Date

    private enum CodingKeys: String, CodingKey {
        case lines = "Lines"
        case expirationTime = "ExpirationTime"
    }
}
