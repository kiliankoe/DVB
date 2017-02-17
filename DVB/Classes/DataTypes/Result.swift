//
//  Result.swift
//  Pods
//
//  Created by Kilian Költzsch on 06/05/16.
//
//

import Foundation

public enum Result<Val, Err: Error> {
    case success(Val)
    case failure(Err)
}
