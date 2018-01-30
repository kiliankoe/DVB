import Foundation
import XCTest
@testable import DVB

// swiftlint:disable identifier_name

enum TestError: Error {
    case error
}

class ResultTests: XCTestCase {

    var success: Result<String> = .success("success")
    var failure: Result<String> = .failure(TestError.error)

    func testGet() {
        // The compiler can see that this will be successful? o.O
        XCTAssertEqual(try success.get(), "success")

        do {
            _ = try failure.get()
        } catch let e {
            // swiftlint:disable:next force_cast
            XCTAssertEqual((e as! TestError), .error)
        }
    }

    func testSuccess() {
        XCTAssertEqual(success.success, .some("success"))
        XCTAssertEqual(failure.success, .none)
    }

    func testFailure() {
        XCTAssertEqual((success.failure as? TestError), .none)
        XCTAssertEqual((failure.failure as? TestError), .some(TestError.error))
    }

    func testOperator() {
        XCTAssertEqual(success ?? "default", "success")
        XCTAssertEqual(failure ?? "default", "default")
    }
}
