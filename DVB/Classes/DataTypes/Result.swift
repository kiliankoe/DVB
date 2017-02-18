//
//  Result.swift
//  Pods
//
//  Created by Kilian Költzsch on 06/05/16.
//
//

import Foundation

public enum Result<Value, Err: Error> {
    case success(Value)
    case failure(Err)

    public func get() throws -> Value {
        switch self {
        case .success(let x): return x
        case .failure(let e): throw e
        }
    }

    public var success: Value? {
        switch self {
        case .success(let x): return x
        case .failure(_): return nil
        }
    }

    public var failure: Err? {
        switch self {
        case .success(_): return nil
        case .failure(let e): return e
        }
    }
}

public func ?? <T,E>(result: Result<T,E>, defaultValue: @autoclosure () -> T) -> T {
    switch result {
    case .success(let x): return x
    case .failure(_): return defaultValue()
    }
}
