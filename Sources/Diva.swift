import Foundation

public struct Diva {
    public let number: String
    public let network: String
}

extension Diva: FromJSON {
    init?(json: JSON) {
        guard let number = json["Number"] as? String,
            let network = json["Network"] as? String else {
                return nil
        }
        self.number = number
        self.network = network
    }
}
