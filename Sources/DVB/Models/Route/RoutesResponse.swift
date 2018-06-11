import Foundation

public struct RoutesResponse {
    public let routes: [Route]
    public let sessionId: String
}

extension RoutesResponse: Decodable {
    private enum CodingKeys: String, CodingKey {
        case routes = "Routes"
        case sessionId = "SessionId"
    }
}

extension RoutesResponse: Equatable {}
