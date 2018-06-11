extension Route {
    public struct MapData {
        public let mode: String
        public let points: [WGSCoordinate]
    }
}

extension Route.MapData: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)

        let components = string.components(separatedBy: "|")
        guard components.count % 2 == 0 else {
            throw DecodingError.dataCorruptedError(in: container,
                                                   debugDescription: "MapData expects an even number of coordinates incl. a mode at the beginning and an empty value at the end.")
        }

        guard let mode = components.first else {
            throw DecodingError.dataCorruptedError(in: container,
                                                   debugDescription: "Expected to find mode identifier as the first value.")
        }

        let gkCoords = components
            .dropFirst() // transportmode
            .dropLast() // empty value
            .compactMap { Double($0) }

        guard gkCoords.count % 2 == 0 else {
            throw DVBError.decode
        }

        // I'd love an implementation of `chunk` in the stdlib...
        var coordTuples = [(Double, Double)]()
        // swiftlint:disable:next identifier_name
        for i in 0 ..< gkCoords.count - 1 {
            coordTuples.append((gkCoords[i], gkCoords[i + 1]))
        }

        let coords = coordTuples
            .compactMap { GKCoordinate(x: $0.0, y: $0.1).asWGS }

        self.mode = mode
        self.points = coords
    }
}

extension Route.MapData: Equatable {}

extension Route.MapData: Hashable {}
