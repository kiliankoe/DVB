//
//  RouteChange.swift
//  Pods
//
//  Created by Kilian Költzsch on 09/05/16.
//
//

import Foundation
import Kanna

/// A temporary change in the network e.g. due to construction.
public struct RouteChange {

    /// Title containing the affected line and stop.
    public let title: String

    /// Raw detail HTML with further information regarding the change.
    public let rawDetails: String

    /// Initialize a RouteChange
    ///
    /// - parameter title:      title containing the affected line and stop
    /// - parameter rawDetails: detail text with further information regarding the change
    ///
    /// - returns: new RouteChange
    public init(title: String, rawDetails: String) {
        self.title = title
        self.rawDetails = rawDetails
    }

    /// Identifier of the affected line.
    public var affectedLine: String? {
        if let lineRange = title.range(of: "(\\d+)", options: .regularExpression) {
            return title.substring(with: lineRange)
        }
        return nil
    }

    /// Affected timeframe, e.g. "ab Mo, 09.05.2016, 06:00 Uhr bis Fr, 20.05.2016, 22:00 Uhr"
    public var timeframe: String? {
        let html = Kanna.HTML(html: rawDetails, encoding: .utf8)
        return html?.css("p:nth-child(1)").first?.text
    }

    /// List of all route change details
    public var details: [String]? {
        let html = Kanna.HTML(html: rawDetails, encoding: .utf8)
        var optionalDetails = html?.css("p").map { $0.text }
        optionalDetails?.removeFirst()
        let details = optionalDetails?.flatMap { $0 }
        return details
    }
}

extension RouteChange: CustomStringConvertible {
    /// A textual representation of `self`.
    public var description: String {
        return title
    }
}
