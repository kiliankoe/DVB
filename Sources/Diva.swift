import Foundation

public struct Diva {
    let number: String
    let network: String
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
