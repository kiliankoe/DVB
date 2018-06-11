import Foundation

public struct RouteChangeResponse {
    public let lines: [RouteChange.Line]
    public let changes: [RouteChange]
}

extension RouteChangeResponse: Decodable {
    private enum CodingKeys: String, CodingKey {
        case lines = "Lines"
        case changes = "Changes"
    }
}

extension RouteChangeResponse: Equatable {}
