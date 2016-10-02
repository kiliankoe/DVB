//
//  DVBError.swift
//  Pods
//
//  Created by Kilian Költzsch on 06/05/16.
//
//

import Foundation

/// Error type used by DVB
///
/// - request: There's something wrong with the request being sent
/// - server:  The server returned an error or no data, see statusCode
/// - decode:  The returned data is malformed and could not be decoded
public enum DVBError: Error {
    case request
    case server(statusCode: Int)
    case decode
}
