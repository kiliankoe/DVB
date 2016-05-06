//
//  DVBError.swift
//  Pods
//
//  Created by Kilian Költzsch on 06/05/16.
//
//

import Foundation

/**
 Error type used by DVB

 - Request: There's something wrong with the request being sent
 - Server:  The server returned an error or no data, statusCode is included in error
 - JSON:    The returned JSON data is malformed
 */
enum DVBError: ErrorType {
    case Request
    case Server(statusCode: Int)
    case JSON
}
