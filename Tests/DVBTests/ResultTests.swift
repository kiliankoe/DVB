import Foundation
import XCTest
@testable import DVB

enum TestError: Error {
    case error
}

class ResultTests: XCTestCase {

    var success: Result<String>!
    var failure: Result<String>!

    override func setUp() {
        success = .success("success")
        failure = .failure(TestError.error)
    }

    func testGet() {
        // The compiler can see that this will be successful? o.O
        XCTAssertEqual(try success.get(), "success")

        do {
            let _ = try failure.get()
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
