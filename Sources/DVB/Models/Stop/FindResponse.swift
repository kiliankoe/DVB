import Foundation

public struct FindResponse {
    public let stops: [Stop]
    public let expirationTime: Date?
}

extension FindResponse: Decodable {
    private enum CodingKeys: String, CodingKey {
        case stops = "Points"
        case expirationTime = "ExpirationTime"
    }
}

extension FindResponse: Equatable {}
