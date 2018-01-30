import Foundation

internal extension Date {
    /// Generate a date of the format `/Date(1487458060455+0100)/`
    var sapPattern: String {
        let millis = Int(self.timeIntervalSince1970 * 1000)
        let timezone = TimeZone.current.secondsFromGMT() / 3600 * 100
        return String(format: "/Date(\(millis)+%04d)/", timezone)
    }

    private static let iso8601Formatter: DateFormatter = {
        // swiftlint:disable:next identifier_name
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        df.timeZone = TimeZone(identifier: "UTC")
        return df
    }()

    var iso8601: String {
        return Date.iso8601Formatter.string(from: self)
    }

    init?(fromSAPPattern pattern: String) {
        // swiftlint:disable:next force_try
        let regex = try! NSRegularExpression(pattern: "/Date\\((\\d+)(\\+|-)(\\d{2})(\\d{2})\\)/", options: [])
        guard let match = regex.firstMatch(in: pattern, options: [], range: NSRange(location: 0, length: pattern.count)) else { return nil }

        let nsstr = pattern as NSString
        guard let millisecond = Double(nsstr.substring(with: match.range(at: 1))) else { return nil }
//        let sign = nsstr.substring(with: match.range(at: 2))
//        let hour = Double(nsstr.substring(with: match.range(at: 3)))!
//        let minute = Double(nsstr.substring(with: match.range(at: 4)))!

        // TODO: Check this! It's probably broken now after the timechange. I'm guessing it's an hour behind, but the timezone does actually matter?
        // It may appear that this behaviour is wrong, which it is. But since the API is returning "malformed" values here, we're accommodating accordingly.
//        let offset = (sign == "+" ? 1 : -1) * (hour * 3600.0 + minute * 60.0)
        let offset = 0.0

        self = Date(timeIntervalSince1970: millisecond / 1000 + offset)
    }
}
