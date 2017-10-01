import Foundation

internal extension Date {
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

extension Date: ValueType {
    public static func value(from object: Any) throws -> Date {
        guard let dateString = object as? String else {
            throw MarshalError.typeMismatch(expected: String.self, actual: type(of: object))
        }

        // swiftlint:disable:next force_try
        let regex = try! NSRegularExpression(pattern: "/Date\\((\\d+)(\\+|-)(\\d{2})(\\d{2})\\)/", options: [])
        guard let match = regex.firstMatch(in: dateString, options: [], range: NSRange(location: 0, length: dateString.characters.count)) else {
            throw MarshalError.typeMismatch(expected: "Valid Date String", actual: dateString)
        }

        let nsstr = dateString as NSString
        let millisecond = Double(nsstr.substring(with: match.rangeAt(1)))!
        let sign = nsstr.substring(with: match.rangeAt(2))
        let hour = Double(nsstr.substring(with: match.rangeAt(3)))!
        let minute = Double(nsstr.substring(with: match.rangeAt(4)))!

        // TODO: Check this! It's probably broken now after the timechange. I'm guessing it's an hour behind, but the timezone does actually matter?
        // It may appear that this behaviour is wrong, which it is. But since the API is returning "malformed" values here, we're accommodating accordingly.
//        let offset = (sign == "+" ? 1 : -1) * (hour * 3600.0 + minute * 60.0)
        let offset = 0.0

        return Date(timeIntervalSince1970: millisecond / 1000 + offset)
    }
}
