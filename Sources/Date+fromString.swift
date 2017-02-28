import Foundation

internal extension Date {
    /// Init with a string of the format "/Date(1487458060455+0100)/"
    init?(from dateString: String) {
        let millisWithTZ = dateString
            .replacingOccurrences(of: "/Date(", with: "")
            .replacingOccurrences(of: ")/", with: "")

        var components = [String]()
        if millisWithTZ.contains("+") {
            components = millisWithTZ.components(separatedBy: "+")
        } else if millisWithTZ.contains("-") {
            components = millisWithTZ.components(separatedBy: "-")
        } else {
            return nil
        }

        guard let millis = Int(components[0]) else { return nil }
        let seconds = Double(millis) / 1000

        self = Date(timeIntervalSince1970: seconds)
    }

    /// Generate a date of the format `/Date(1487458060455+0100)/`
    var datestring: String {
        let millis = Int(self.timeIntervalSince1970 * 1000)
        let timezone = TimeZone.current.secondsFromGMT() / 3600 * 100
        return String(format: "/Date(\(millis)+%04d)/", timezone)
    }

    private static let iso8601Formatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        df.timeZone = TimeZone(identifier: "UTC")
        return df
    }()

    var iso8601: String {
        return Date.iso8601Formatter.string(from: self)
    }
}
