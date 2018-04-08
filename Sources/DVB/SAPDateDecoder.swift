import Foundation

enum SAPDateDecoder {
    static func strategy(decoder: Decoder) throws -> Date {
        let container = try decoder.singleValueContainer()
        let dateStr = try container.decode(String.self)
        guard let date = Date(fromSAPPattern: dateStr) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Illegal date value: \(dateStr)")
        }
        return date
    }
}
