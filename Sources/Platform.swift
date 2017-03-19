import Foundation
import Marshal

public struct Platform {
    public let name: String
    public let type: String
}

extension Platform: Unmarshaling {
    public init(object: MarshaledObject) throws {
        self.name = try object <| "Name"
        self.type = try object <| "Type"
    }
}
