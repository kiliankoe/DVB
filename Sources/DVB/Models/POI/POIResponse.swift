import Foundation

public struct POIResponse {
    public let pins: [POI]
    public let expirationTime: Date
}

extension POIResponse: Decodable {
    private enum CodingKeys: String, CodingKey {
        case pins = "Pins"
        case expirationTime = "ExpirationTime"
    }
}

extension POIResponse: Equatable {}
