//
//  Result.swift
//  Pods
//
//  Created by Kilian Költzsch on 06/05/16.
//
//

import Foundation

enum Result<T, E: ErrorType> {
    case Success(value: T)
    case Failure(error: E)
}
