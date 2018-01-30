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
        case let .success(value): return value
        case let .failure(error): throw error
        }
    }

    public var success: Value? {
        switch self {
        case let .success(value): return value
        case .failure: return nil
        }
    }

    public var failure: Error? {
        switch self {
        case .success: return nil
        case let .failure(error): return error
        }
    }
}

public func ?? <T>(result: Result<T>, defaultValue: @autoclosure () -> T) -> T {
    switch result {
    case let .success(value): return value
    case .failure: return defaultValue()
    }
}
