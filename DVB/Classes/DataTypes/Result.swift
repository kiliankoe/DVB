//
//  Result.swift
//  Pods
//
//  Created by Kilian Költzsch on 06/05/16.
//
//

import Foundation

/// Result enum type used internally
///
/// - success: Success
/// - failure: Failure
enum Result<T, E: Error> {
    case success(value: T)
    case failure(error: E)
}
