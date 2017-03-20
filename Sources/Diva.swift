import Foundation
import Marshal

public struct Diva {
    public let number: String
    public let network: String
}

extension Diva: Unmarshaling {
    public init(object: MarshaledObject) throws {
        self.number = try object <| "Number"
        self.network = try object <| "Network"
    }
}
