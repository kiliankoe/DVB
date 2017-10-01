import Foundation

public struct Diva {
    public let number: String
    public let network: String
}

extension Diva: Unmarshaling {
    public init(object: MarshaledObject) throws {
        number = try object <| "Number"
        network = try object <| "Network"
    }
}
