import Foundation

extension RouteChange {
    public struct ValidityPeriod {
        public let begin: Date
        public let end: Date?
    }
}

extension RouteChange.ValidityPeriod: Decodable {
    private enum CodingKeys: String, CodingKey {
        case begin = "Begin"
        case end = "End"
    }
}

extension RouteChange.ValidityPeriod: Equatable {}

extension RouteChange.ValidityPeriod: Hashable {}
