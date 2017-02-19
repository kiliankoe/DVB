import Foundation

public enum Result<Value> {
    case success(Value)
    case failure(Error)

    init(success value: Value) {
        self = .success(value)
    }

    init(failure error: Error) {
        self = .failure(error)
    }

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

    public var failure: Error? {
        switch self {
        case .success(_): return nil
        case .failure(let e): return e
        }
    }
}

public func ?? <T>(result: Result<T>, defaultValue: @autoclosure () -> T) -> T {
    switch result {
    case .success(let x): return x
    case .failure(_): return defaultValue()
    }
}
