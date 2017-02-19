import Foundation

typealias JSON = [String: Any]

protocol FromJSON {
    init?(json: JSON)
}

extension FromJSON {
    init?(anyJSON: Any) {
        guard let json = anyJSON as? JSON else { return nil }
        self.init(json: json)
    }
}
