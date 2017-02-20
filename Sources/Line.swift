import Foundation

public struct Line {
    public let id: String
    public let name: String
    public let transportationCompany: String
    public let mode: Mode
    public let divas: [Diva]
    public let changes: [String]
}

extension Line: FromJSON {
    init?(json: JSON) {
        guard let id = json["Id"] as? String,
            let name = json["Name"] as? String,
            let company = json["TransportationCompany"] as? String,
            let modeStr = json["Mot"] as? String,
            let mode = Mode(rawValue: modeStr.lowercased()),
            let divas = json["Divas"] as? [JSON],
            let changes = json["Changes"] as? [String] else {
                return nil
        }

        self.id = id
        self.name = name
        self.transportationCompany = company
        self.mode = mode
        self.divas = divas.map {Diva(json: $0)}.flatMap {$0}
        self.changes = changes
    }
}
