import XCTest
@testable import StopTests
@testable import DepartureTests
@testable import FindTests
@testable import MonitorTests

XCTMain([
    testCase(StopTests.allTests),
    testCase(DepartureTests.allTests),
    testCase(FindTests.allTests),
    testCase(MonitorTests.allTests),
])
