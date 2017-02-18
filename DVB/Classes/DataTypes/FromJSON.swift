//
//  FromJSON.swift
//  Pods
//
//  Created by Kilian Költzsch on 18/02/2017.
//
//

import Foundation

typealias JSON = [String: Any]

protocol FromJSON {
    init?(json: JSON)
}
