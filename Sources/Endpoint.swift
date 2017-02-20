import Foundation

enum Endpoint {
    static let base = URL(string: "https://webapi.vvo-online.de/")!

    // swiftlint:disable:next variable_name
    private static let tr = URL(string: "tr/", relativeTo: Endpoint.base)!
    static let pointfinder = URL(string: "pointfinder", relativeTo: Endpoint.tr)!
    static let trips = URL(string: "trips", relativeTo: Endpoint.tr)!

    static let departureMonitor = URL(string: "dm/", relativeTo: Endpoint.base)!
    static let perlschnur = URL(string: "trip", relativeTo: Endpoint.departureMonitor)!

    private static let stt = URL(string: "stt/", relativeTo: Endpoint.base)!
    static let lines = URL(string: "lines", relativeTo: Endpoint.stt)!

    private static let map = URL(string: "map/", relativeTo: Endpoint.base)!
    static let mapPins = URL(string: "pins", relativeTo: Endpoint.map)!

    static let routeChanges = URL(string: "rc", relativeTo: Endpoint.base)!
}
