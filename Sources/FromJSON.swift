import Foundation

typealias JSON = [String: Any]

protocol FromJSON {
    init(json: JSON) throws
}

extension FromJSON {
    init(anyJSON: Any) throws {
        guard let json = anyJSON as? JSON else { throw DVBError.decode }
        try self.init(json: json)
    }
}
