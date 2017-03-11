import Foundation
import Marshal

public struct Platform {
    public let name: String
    public let type: String
}

extension Platform: FromJSON {
    init(json: JSON) throws {
        guard
            let name = json["Name"] as? String,
            let type = json["Type"] as? String
        else {
                throw DVBError.decode
        }
        self.name = name
        self.type = type
    }
}

extension Platform: Unmarshaling {
    public init(object: MarshaledObject) throws {
        self.name = try object.value(for: "Name")
        self.type = try object.value(for: "Type")
    }
}
