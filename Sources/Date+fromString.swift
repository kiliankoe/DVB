import Foundation

internal extension Date {
    // Init with a string of the format "/Date(1487458060455+0100)/"
    init?(from dateString: String) {
        let components = dateString
            .replacingOccurrences(of: "/Date(", with: "")
            .replacingOccurrences(of: ")/", with: "")
            .components(separatedBy: "+")

        guard let millis = Int(components[0]) else { return nil }
        let seconds = Double(millis) / 1000

        self = Date(timeIntervalSince1970: seconds)
    }
}
