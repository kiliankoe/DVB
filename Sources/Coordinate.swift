import Foundation

public struct Coordinate {
    public let latitude: Double
    public let longitude: Double
}

extension Coordinate {
    var asGK: (x: Double, y: Double)? {
        return wgs2gk(wgs: self)
    }

    // swiftlint:disable:next variable_name
    init?(x: Double, y: Double) {
        guard let wgs = gk2wgs(gk: (x: x, y: y)) else { return nil }
        self = wgs
    }
}
