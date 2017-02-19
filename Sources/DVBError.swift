import Foundation

/// Error type used by DVB
///
/// - network:  The request could not be sent or something weird went wrong.
/// - server:   The server returned an error or no data, see statusCode.
/// - response: The server's response is not of the expected format.
/// - request:  The server states there's an error with the sent request, check contained data.
/// - decode:   The returned data is malformed and could not be decoded.
public enum DVBError: Error {
    case network
    case server(statusCode: Int)
    case response
    case request(status: String, message: String)
    case decode
}
