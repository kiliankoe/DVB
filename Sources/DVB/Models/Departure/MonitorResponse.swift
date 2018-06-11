import Foundation

public struct MonitorResponse {
    public let stopName: String
    public let place: String
    public let expirationTime: Date
    public let departures: [Departure]
}

extension MonitorResponse: Decodable {
    private enum CodingKeys: String, CodingKey {
        case stopName = "Name"
        case place = "Place"
        case expirationTime = "ExpirationTime"
        case departures = "Departures"
    }
}

extension MonitorResponse: Equatable {}
