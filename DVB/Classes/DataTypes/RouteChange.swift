//
//  RouteChange.swift
//  Pods
//
//  Created by Kilian Költzsch on 09/05/16.
//
//

import Foundation

/**
 *  A temporary change in the network e.g. due to construction.
 */
public struct RouteChange {

    /// Title containing the affected line and stop.
    public let title: String

    /// Detail text with further information regarding the change.
    public let details: String

    /**
     Initialize a RouteChange

     - parameter title:   title containing the affected line and stop.
     - parameter details: detail text with further information regarding the change.

     - returns: new RouteChange
     */
    public init(title: String, details: String) {
        self.title = title
        self.details = details
    }

    /// Identifier of the affected line.
    public var affectedLine: String? {
        if let lineRange = title.rangeOfString("(\\d+)", options: .RegularExpressionSearch) {
            return title.substringWithRange(lineRange)
        }
        return nil
    }
}

extension RouteChange: CustomStringConvertible {
    /// A textual representation of `self`.
    public var description: String {
        return title
    }
}
